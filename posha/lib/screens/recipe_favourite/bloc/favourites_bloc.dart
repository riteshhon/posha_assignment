import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posha/core/services/favorites_service.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_state.dart';

/// Unified Favorites BLoC
/// Manages both favorite IDs and full recipe data
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final RecipeRepository? _repository;

  FavoritesBloc({RecipeRepository? repository})
    : _repository = repository,
      super(const FavoritesInitial()) {
    on<FavoritesInitialized>(_onInitialized);
    on<FavoriteRecipesInitialized>(_onRecipesInitialized);
    on<FavoriteRecipesRefreshed>(_onRecipesRefreshed);
    on<FavoriteToggled>(_onToggled);
    on<FavoriteAdded>(_onAdded);
    on<FavoriteRemoved>(_onRemoved);
  }

  /// Initialize favorites (loads IDs only - for favorite button)
  Future<void> _onInitialized(
    FavoritesInitialized event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favoriteIds = await FavoritesService.getFavoriteIds();
      emit(FavoritesLoaded(favoriteIds));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// Initialize and load full favorite recipes data
  Future<void> _onRecipesInitialized(
    FavoriteRecipesInitialized event,
    Emitter<FavoritesState> emit,
  ) async {
    await _loadFavoriteRecipes(emit);
  }

  /// Refresh favorite recipes list
  Future<void> _onRecipesRefreshed(
    FavoriteRecipesRefreshed event,
    Emitter<FavoritesState> emit,
  ) async {
    await _loadFavoriteRecipes(emit);
  }

  /// Load full favorite recipes data
  Future<void> _loadFavoriteRecipes(Emitter<FavoritesState> emit) async {
    final repository = _repository;
    if (repository == null) {
      emit(const FavoritesError('Repository not provided'));
      return;
    }

    emit(const FavoriteRecipesLoading());

    try {
      final favoriteIds = await FavoritesService.getFavoriteIds();

      if (favoriteIds.isEmpty) {
        emit(const FavoriteRecipesEmpty());
        return;
      }

      // Fetch all favorite recipes in parallel
      final futures = favoriteIds.map((id) => repository.getRecipeById(id));
      final results = await Future.wait(futures);

      // Filter out null values
      final recipes = results.whereType<RecipeModel>().toList();

      if (recipes.isEmpty) {
        emit(const FavoriteRecipesEmpty());
      } else {
        emit(FavoriteRecipesLoaded(recipes: recipes, favoriteIds: favoriteIds));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// Toggle favorite status
  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final success = await FavoritesService.toggleFavorite(event.recipeId);
      if (!success) return;

      // Get updated favorite IDs
      final favoriteIds = await FavoritesService.getFavoriteIds();

      // If currently showing recipes, update immediately for instant feedback
      if (state is FavoriteRecipesLoaded) {
        final currentState = state as FavoriteRecipesLoaded;
        final wasFav = currentState.isFavorite(event.recipeId);
        final repository = _repository;

        if (wasFav) {
          // Remove from list immediately
          final updatedRecipes = currentState.recipes
              .where((recipe) => recipe.id != event.recipeId)
              .toList();

          if (updatedRecipes.isEmpty) {
            emit(const FavoriteRecipesEmpty());
          } else {
            emit(
              FavoriteRecipesLoaded(
                recipes: updatedRecipes,
                favoriteIds: favoriteIds,
              ),
            );
          }
        } else {
          // Add to list immediately
          if (repository != null) {
            final newRecipe = await repository.getRecipeById(event.recipeId);
            if (newRecipe != null) {
              final updatedRecipes = List<RecipeModel>.from(
                currentState.recipes,
              )..add(newRecipe);
              emit(
                FavoriteRecipesLoaded(
                  recipes: updatedRecipes,
                  favoriteIds: favoriteIds,
                ),
              );
            } else {
              // Recipe not found, refresh the list
              await _loadFavoriteRecipes(emit);
            }
          } else {
            // No repository, just update IDs
            emit(FavoritesLoaded(favoriteIds));
          }
        }
      } else if (_repository != null) {
        // If not showing recipes, load them to update favorites screen
        await _loadFavoriteRecipes(emit);
      } else {
        // No repository, just update IDs
        emit(FavoritesLoaded(favoriteIds));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// Add recipe to favorites
  Future<void> _onAdded(
    FavoriteAdded event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final success = await FavoritesService.addFavorite(event.recipeId);
      if (!success) return;

      // Get updated favorite IDs
      final favoriteIds = await FavoritesService.getFavoriteIds();

      // If currently showing recipes, update immediately for instant feedback
      if (state is FavoriteRecipesLoaded) {
        final currentState = state as FavoriteRecipesLoaded;
        final repository = _repository;
        if (repository != null) {
          final newRecipe = await repository.getRecipeById(event.recipeId);
          if (newRecipe != null) {
            final updatedRecipes = List<RecipeModel>.from(currentState.recipes)
              ..add(newRecipe);
            emit(
              FavoriteRecipesLoaded(
                recipes: updatedRecipes,
                favoriteIds: favoriteIds,
              ),
            );
          } else {
            // Recipe not found, refresh the list
            await _loadFavoriteRecipes(emit);
          }
        } else {
          // No repository, just update IDs
          emit(FavoritesLoaded(favoriteIds));
        }
      } else if (_repository != null) {
        // If not showing recipes, load them to update favorites screen
        await _loadFavoriteRecipes(emit);
      } else {
        // No repository, just update IDs
        emit(FavoritesLoaded(favoriteIds));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// Remove recipe from favorites
  Future<void> _onRemoved(
    FavoriteRemoved event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final success = await FavoritesService.removeFavorite(event.recipeId);
      if (!success) return;

      // Get updated favorite IDs
      final favoriteIds = await FavoritesService.getFavoriteIds();

      // If currently showing recipes, update immediately for instant feedback
      if (state is FavoriteRecipesLoaded) {
        final currentState = state as FavoriteRecipesLoaded;
        final updatedRecipes = currentState.recipes
            .where((recipe) => recipe.id != event.recipeId)
            .toList();

        if (updatedRecipes.isEmpty) {
          emit(const FavoriteRecipesEmpty());
        } else {
          emit(
            FavoriteRecipesLoaded(
              recipes: updatedRecipes,
              favoriteIds: favoriteIds,
            ),
          );
        }
      } else if (_repository != null) {
        // If not showing recipes, load them to update favorites screen
        await _loadFavoriteRecipes(emit);
      } else {
        // No repository, just update IDs
        emit(FavoritesLoaded(favoriteIds));
      }
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
