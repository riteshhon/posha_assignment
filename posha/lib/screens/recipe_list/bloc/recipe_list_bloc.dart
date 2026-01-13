import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';

/// Recipe List BLoC
class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final RecipeRepository _repository;
  Timer? _debounceTimer;
  List<RecipeModel> _baseRecipes = [];

  static const Duration _debounceDuration = Duration(milliseconds: 500);
  static const String _initialSearchQuery = 'a';

  RecipeListBloc({required RecipeRepository repository})
    : _repository = repository,
      super(const RecipeListInitial()) {
    on<RecipeListInitialized>(_onInitialized);
    on<RecipeListSearchChanged>(_onSearchChanged);
    on<RecipeListCategoryFilterChanged>(_onCategoryFilterChanged);
    on<RecipeListAreaFilterChanged>(_onAreaFilterChanged);
    on<RecipeListFiltersCleared>(_onFiltersCleared);
    on<RecipeListViewModeToggled>(_onViewModeToggled);
    on<RecipeListSortChanged>(_onSortChanged);
    on<RecipeListRefreshed>(_onRefreshed);
    on<RecipeListFiltersToggled>(_onFiltersToggled);
    on<RecipeListFilterPanelOpened>(_onFilterPanelOpened);
    on<RecipeListFilterPanelClosed>(_onFilterPanelClosed);
  }

  Future<void> _onInitialized(
    RecipeListInitialized event,
    Emitter<RecipeListState> emit,
  ) async {
    emit(const RecipeListLoading());
    try {
      final recipes = await _repository.searchByName(_initialSearchQuery);
      final categories = await _repository.getCategories();
      final areas = await _repository.getAreas();

      _baseRecipes = recipes;

      emit(
        RecipeListLoaded(
          recipes: recipes,
          filteredRecipes: recipes,
          categories: categories.map((c) => c.name).toList(),
          areas: areas.map((a) => a.name).toList(),
        ),
      );
    } catch (e) {
      emit(RecipeListError(e.toString()));
    }
  }

  Future<void> _onSearchChanged(
    RecipeListSearchChanged event,
    Emitter<RecipeListState> emit,
  ) async {
    _debounceTimer?.cancel();

    if (state is! RecipeListLoaded) return;
    final currentState = state as RecipeListLoaded;

    // Handle empty query - reset to appropriate recipes
    if (event.query.isEmpty) {
      await _handleSearchCleared(currentState, emit);
      return;
    }

    // Instant local filtering
    final recipesToFilter = _getRecipesForFiltering(currentState);
    final instantFiltered = _applyFilters(
      recipesToFilter,
      event.query,
      currentState.selectedCategory,
      currentState.selectedArea,
      currentState.sortType,
    );

    emit(
      currentState.copyWith(
        searchQuery: event.query,
        filteredRecipes: instantFiltered,
      ),
    );

    // Debounced API call
    _scheduleDebouncedSearch(event.query, currentState);
  }

  Future<void> _handleSearchCleared(
    RecipeListLoaded currentState,
    Emitter<RecipeListState> emit,
  ) async {
    if (currentState.hasActiveFilters) {
      final recipes = await _fetchRecipesForActiveFilters(currentState, emit);
      if (recipes == null) return; // Error already emitted

      final filtered = _applyFilters(
        recipes,
        null,
        currentState.selectedCategory,
        currentState.selectedArea,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: recipes,
          filteredRecipes: filtered,
          searchQuery: null,
          clearSearchQuery: true,
        ),
      );
    } else {
      final baseRecipes = _baseRecipes.isNotEmpty
          ? _baseRecipes
          : currentState.recipes;
      final filtered = _applyFilters(
        baseRecipes,
        null,
        null,
        null,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: baseRecipes,
          filteredRecipes: filtered,
          searchQuery: null,
          clearSearchQuery: true,
        ),
      );
    }
  }

  Future<List<RecipeModel>?> _fetchRecipesForActiveFilters(
    RecipeListLoaded state,
    Emitter<RecipeListState> emit,
  ) async {
    try {
      if (state.selectedCategory != null && state.selectedArea != null) {
        // Both filters: fetch by category, area filter applied locally
        final categoryRecipes = await _repository.filterByCategory(
          state.selectedCategory!,
        );
        return await _repository.getFullRecipesFromSummaries(categoryRecipes);
      } else if (state.selectedCategory != null) {
        // Only category filter
        final categoryRecipes = await _repository.filterByCategory(
          state.selectedCategory!,
        );
        return await _repository.getFullRecipesFromSummaries(categoryRecipes);
      } else if (state.selectedArea != null) {
        // Only area filter
        final areaRecipes = await _repository.filterByArea(state.selectedArea!);
        return await _repository.getFullRecipesFromSummaries(areaRecipes);
      }
    } catch (e) {
      emit(RecipeListError(e.toString()));
    }
    return null;
  }

  void _scheduleDebouncedSearch(String query, RecipeListLoaded currentState) {
    final categorySnapshot = currentState.selectedCategory;
    final areaSnapshot = currentState.selectedArea;
    final sortSnapshot = currentState.sortType;

    _debounceTimer = Timer(_debounceDuration, () async {
      if (state is! RecipeListLoaded) return;
      final stateSnapshot = state as RecipeListLoaded;

      if (stateSnapshot.searchQuery != query || query.isEmpty) return;

      try {
        final recipes = await _repository.searchByName(query);
        final filtered = _applyFilters(
          recipes,
          query,
          categorySnapshot,
          areaSnapshot,
          sortSnapshot,
        );

        if (state is RecipeListLoaded) {
          final finalState = state as RecipeListLoaded;
          if (finalState.searchQuery == query) {
            emit(
              finalState.copyWith(
                recipes: recipes,
                filteredRecipes: filtered,
                searchQuery: query,
              ),
            );
          }
        }
      } catch (e) {
        // Keep local results on error
      }
    });
  }

  Future<void> _onCategoryFilterChanged(
    RecipeListCategoryFilterChanged event,
    Emitter<RecipeListState> emit,
  ) async {
    if (state is! RecipeListLoaded) return;
    final currentState = state as RecipeListLoaded;

    // Skip if same value selected
    if (event.category != null &&
        currentState.selectedCategory == event.category) {
      return;
    }

    // Handle clearing category
    if (event.category == null) {
      await _handleCategoryCleared(currentState, emit);
      return;
    }

    // Handle setting category
    await _handleCategorySet(currentState, event.category!, emit);
  }

  Future<void> _onAreaFilterChanged(
    RecipeListAreaFilterChanged event,
    Emitter<RecipeListState> emit,
  ) async {
    if (state is! RecipeListLoaded) return;
    final currentState = state as RecipeListLoaded;

    // Skip if same value selected
    if (event.area != null && currentState.selectedArea == event.area) {
      return;
    }

    // Handle clearing area
    if (event.area == null) {
      await _handleAreaCleared(currentState, emit);
      return;
    }

    // Handle setting area
    await _handleAreaSet(currentState, event.area!, emit);
  }

  Future<void> _handleCategoryCleared(
    RecipeListLoaded currentState,
    Emitter<RecipeListState> emit,
  ) async {
    // Skip if already cleared and no area filter
    if (currentState.selectedCategory == null &&
        currentState.selectedArea == null) {
      return;
    }

    // Instant local filtering if search is active
    if (currentState.hasSearchQuery) {
      final filtered = _applyFilters(
        currentState.recipes,
        currentState.searchQuery,
        null,
        currentState.selectedArea,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          filteredRecipes: filtered,
          selectedCategory: null,
        ),
      );
      return;
    }

    // Fetch by area if active
    if (currentState.selectedArea != null) {
      emit(currentState.copyWith(isSearching: true));
      try {
        final areaRecipes = await _repository.filterByArea(
          currentState.selectedArea!,
        );
        final recipes = await _repository.getFullRecipesFromSummaries(
          areaRecipes,
        );
        final filtered = _applyFilters(
          recipes,
          null,
          null,
          currentState.selectedArea,
          currentState.sortType,
        );

        emit(
          currentState.copyWith(
            recipes: recipes,
            filteredRecipes: filtered,
            selectedCategory: null,
            isSearching: false,
          ),
        );
      } catch (e) {
        emit(RecipeListError(e.toString()));
      }
      return;
    }

    // Reset to base recipes
    final baseRecipes = _baseRecipes.isNotEmpty
        ? _baseRecipes
        : currentState.recipes;
    final filtered = _applyFilters(
      baseRecipes,
      null,
      null,
      null,
      currentState.sortType,
    );

    emit(
      currentState.copyWith(
        recipes: baseRecipes,
        filteredRecipes: filtered,
        selectedCategory: null,
      ),
    );
  }

  Future<void> _handleAreaCleared(
    RecipeListLoaded currentState,
    Emitter<RecipeListState> emit,
  ) async {
    // Skip if already cleared and no category filter
    if (currentState.selectedArea == null &&
        currentState.selectedCategory == null) {
      return;
    }

    // Instant local filtering if search is active
    if (currentState.hasSearchQuery) {
      final filtered = _applyFilters(
        currentState.recipes,
        currentState.searchQuery,
        currentState.selectedCategory,
        null,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(filteredRecipes: filtered, selectedArea: null),
      );
      return;
    }

    // Fetch by category if active
    if (currentState.selectedCategory != null) {
      emit(currentState.copyWith(isSearching: true));
      try {
        final categoryRecipes = await _repository.filterByCategory(
          currentState.selectedCategory!,
        );
        final recipes = await _repository.getFullRecipesFromSummaries(
          categoryRecipes,
        );
        final filtered = _applyFilters(
          recipes,
          null,
          currentState.selectedCategory,
          null,
          currentState.sortType,
        );

        emit(
          currentState.copyWith(
            recipes: recipes,
            filteredRecipes: filtered,
            selectedArea: null,
            isSearching: false,
          ),
        );
      } catch (e) {
        emit(RecipeListError(e.toString()));
      }
      return;
    }

    // Reset to base recipes
    final baseRecipes = _baseRecipes.isNotEmpty
        ? _baseRecipes
        : currentState.recipes;
    final filtered = _applyFilters(
      baseRecipes,
      null,
      null,
      null,
      currentState.sortType,
    );

    emit(
      currentState.copyWith(
        recipes: baseRecipes,
        filteredRecipes: filtered,
        selectedArea: null,
      ),
    );
  }

  Future<void> _handleCategorySet(
    RecipeListLoaded currentState,
    String category,
    Emitter<RecipeListState> emit,
  ) async {
    // Instant local filtering if search is active
    if (currentState.hasSearchQuery) {
      final filtered = _applyFilters(
        currentState.recipes,
        currentState.searchQuery,
        category,
        currentState.selectedArea,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          filteredRecipes: filtered,
          selectedCategory: category,
        ),
      );
      return;
    }

    // Fetch from API
    emit(currentState.copyWith(isSearching: true));

    try {
      final recipes = await _fetchRecipesByCategory(category, emit);
      if (recipes == null || recipes.isEmpty) {
        emit(
          currentState.copyWith(
            recipes: [],
            filteredRecipes: [],
            selectedCategory: category,
            isSearching: false,
          ),
        );
        return;
      }

      final filtered = _applyFilters(
        recipes,
        null,
        null,
        currentState.selectedArea,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: recipes,
          filteredRecipes: filtered,
          selectedCategory: category,
          isSearching: false,
        ),
      );
    } catch (e) {
      emit(RecipeListError(e.toString()));
    }
  }

  Future<void> _handleAreaSet(
    RecipeListLoaded currentState,
    String area,
    Emitter<RecipeListState> emit,
  ) async {
    // Instant local filtering if search is active
    if (currentState.hasSearchQuery) {
      final filtered = _applyFilters(
        currentState.recipes,
        currentState.searchQuery,
        currentState.selectedCategory,
        area,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(filteredRecipes: filtered, selectedArea: area),
      );
      return;
    }

    // Fetch from API
    emit(currentState.copyWith(isSearching: true));

    try {
      final recipes = await _fetchRecipesByArea(area, emit);
      if (recipes == null) return;

      final filtered = _applyFilters(
        recipes,
        null,
        currentState.selectedCategory,
        area,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: recipes,
          filteredRecipes: filtered,
          selectedArea: area,
          isSearching: false,
        ),
      );
    } catch (e) {
      emit(RecipeListError(e.toString()));
    }
  }

  Future<List<RecipeModel>?> _fetchRecipesByCategory(
    String category,
    Emitter<RecipeListState> emit,
  ) async {
    try {
      final categoryRecipes = await _repository.filterByCategory(category);
      if (categoryRecipes.isEmpty) return [];
      return await _repository.getFullRecipesFromSummaries(categoryRecipes);
    } catch (e) {
      emit(RecipeListError(e.toString()));
      return null;
    }
  }

  Future<List<RecipeModel>?> _fetchRecipesByArea(
    String area,
    Emitter<RecipeListState> emit,
  ) async {
    try {
      final areaRecipes = await _repository.filterByArea(area);
      return await _repository.getFullRecipesFromSummaries(areaRecipes);
    } catch (e) {
      emit(RecipeListError(e.toString()));
      return null;
    }
  }

  Future<void> _onFiltersCleared(
    RecipeListFiltersCleared event,
    Emitter<RecipeListState> emit,
  ) async {
    if (state is! RecipeListLoaded) return;
    final currentState = state as RecipeListLoaded;

    if (_baseRecipes.isNotEmpty) {
      final filtered = _applyFilters(
        _baseRecipes,
        null,
        null,
        null,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: _baseRecipes,
          filteredRecipes: filtered,
          isSearching: false,
          clearSearchQuery: true,
          clearCategory: true,
          clearArea: true,
        ),
      );
      return;
    }

    emit(const RecipeListLoading());

    try {
      final recipes = await _repository.searchByName(_initialSearchQuery);
      _baseRecipes = recipes;

      final filtered = _applyFilters(
        recipes,
        null,
        null,
        null,
        currentState.sortType,
      );

      emit(
        currentState.copyWith(
          recipes: recipes,
          filteredRecipes: filtered,
          isSearching: false,
          clearSearchQuery: true,
          clearCategory: true,
          clearArea: true,
        ),
      );
    } catch (e) {
      emit(RecipeListError(e.toString()));
    }
  }

  void _onViewModeToggled(
    RecipeListViewModeToggled event,
    Emitter<RecipeListState> emit,
  ) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;
      emit(currentState.copyWith(isGridView: !currentState.isGridView));
    }
  }

  void _onSortChanged(
    RecipeListSortChanged event,
    Emitter<RecipeListState> emit,
  ) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;
      final sorted = _applyFilters(
        currentState.recipes,
        currentState.searchQuery,
        currentState.selectedCategory,
        currentState.selectedArea,
        event.sortType,
      );

      emit(
        currentState.copyWith(
          filteredRecipes: sorted,
          sortType: event.sortType,
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    RecipeListRefreshed event,
    Emitter<RecipeListState> emit,
  ) async {
    add(const RecipeListInitialized());
  }

  void _onFiltersToggled(
    RecipeListFiltersToggled event,
    Emitter<RecipeListState> emit,
  ) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;
      emit(currentState.copyWith(showFilters: !currentState.showFilters));
    }
  }

  void _onFilterPanelOpened(
    RecipeListFilterPanelOpened event,
    Emitter<RecipeListState> emit,
  ) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;
      emit(currentState.copyWith(showFilterPanel: true));
    }
  }

  void _onFilterPanelClosed(
    RecipeListFilterPanelClosed event,
    Emitter<RecipeListState> emit,
  ) {
    if (state is RecipeListLoaded) {
      final currentState = state as RecipeListLoaded;
      emit(currentState.copyWith(showFilterPanel: false));
    }
  }

  List<RecipeModel> _getRecipesForFiltering(RecipeListLoaded state) {
    return _baseRecipes.isNotEmpty &&
            state.selectedCategory == null &&
            state.selectedArea == null
        ? _baseRecipes
        : state.recipes;
  }

  List<RecipeModel> _applyFilters(
    List<RecipeModel> recipes,
    String? searchQuery,
    String? category,
    String? area,
    RecipeListSortType sortType,
  ) {
    Iterable<RecipeModel> filtered = recipes;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filtered = filtered.where(
        (recipe) => recipe.name.toLowerCase().contains(queryLower),
      );
    }

    if (category != null && category.isNotEmpty) {
      final categoryLower = category.toLowerCase().trim();
      filtered = filtered.where(
        (recipe) =>
            recipe.category != null &&
            recipe.category!.toLowerCase().trim() == categoryLower,
      );
    }

    if (area != null && area.isNotEmpty) {
      final areaLower = area.toLowerCase().trim();
      filtered = filtered.where(
        (recipe) =>
            recipe.area != null &&
            recipe.area!.toLowerCase().trim() == areaLower,
      );
    }

    final result = filtered.toList();

    switch (sortType) {
      case RecipeListSortType.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case RecipeListSortType.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case RecipeListSortType.none:
        break;
    }

    return result;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
