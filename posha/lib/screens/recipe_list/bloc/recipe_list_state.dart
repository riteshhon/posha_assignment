import 'package:equatable/equatable.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';

/// Recipe List States
abstract class RecipeListState extends Equatable {
  const RecipeListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RecipeListInitial extends RecipeListState {
  const RecipeListInitial();
}

/// Loading state
class RecipeListLoading extends RecipeListState {
  const RecipeListLoading();
}

/// Loaded state with recipes
class RecipeListLoaded extends RecipeListState {
  final List<RecipeModel> recipes;
  final List<RecipeModel> filteredRecipes;
  final String? searchQuery;
  final String? selectedCategory;
  final String? selectedArea;
  final bool isGridView;
  final RecipeListSortType sortType;
  final List<String> categories;
  final List<String> areas;
  final bool isSearching;
  final bool showFilters;
  final bool showFilterPanel;

  const RecipeListLoaded({
    required this.recipes,
    required this.filteredRecipes,
    this.searchQuery,
    this.selectedCategory,
    this.selectedArea,
    this.isGridView = true,
    this.sortType = RecipeListSortType.none,
    this.categories = const [],
    this.areas = const [],
    this.isSearching = false,
    this.showFilters = false,
    this.showFilterPanel = false,
  });

  RecipeListLoaded copyWith({
    List<RecipeModel>? recipes,
    List<RecipeModel>? filteredRecipes,
    String? searchQuery,
    String? selectedCategory,
    String? selectedArea,
    bool? isGridView,
    RecipeListSortType? sortType,
    List<String>? categories,
    List<String>? areas,
    bool? isSearching,
    bool? showFilters,
    bool? showFilterPanel,
    bool clearSearchQuery = false,
    bool clearCategory = false,
    bool clearArea = false,
  }) {
    return RecipeListLoaded(
      recipes: recipes ?? this.recipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedArea: clearArea ? null : (selectedArea ?? this.selectedArea),
      isGridView: isGridView ?? this.isGridView,
      sortType: sortType ?? this.sortType,
      categories: categories ?? this.categories,
      areas: areas ?? this.areas,
      isSearching: isSearching ?? this.isSearching,
      showFilters: showFilters ?? this.showFilters,
      showFilterPanel: showFilterPanel ?? this.showFilterPanel,
    );
  }

  bool get hasActiveFilters => selectedCategory != null || selectedArea != null;

  bool get hasSearchQuery => searchQuery != null && searchQuery!.isNotEmpty;

  int get activeFilterCount {
    int count = 0;
    if (hasSearchQuery) count++;
    if (selectedCategory != null) count++;
    if (selectedArea != null) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    recipes,
    filteredRecipes,
    searchQuery,
    selectedCategory,
    selectedArea,
    isGridView,
    sortType,
    categories,
    areas,
    isSearching,
    showFilters,
    showFilterPanel,
  ];
}

/// Error state
class RecipeListError extends RecipeListState {
  final String message;

  const RecipeListError(this.message);

  @override
  List<Object?> get props => [message];
}
