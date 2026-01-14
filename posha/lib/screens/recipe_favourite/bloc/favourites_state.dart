import 'package:equatable/equatable.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Unified Favorites States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loading state (for recipes list)
class FavoriteRecipesLoading extends FavoritesState {
  const FavoriteRecipesLoading();
}

/// Loaded state with favorite IDs only (for checking favorite status)
class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;

  const FavoritesLoaded(this.favoriteIds);

  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  FavoritesLoaded copyWith({Set<String>? favoriteIds}) {
    return FavoritesLoaded(favoriteIds ?? this.favoriteIds);
  }

  @override
  List<Object?> get props => [favoriteIds];
}

/// Loaded state with full favorite recipes data
class FavoriteRecipesLoaded extends FavoritesState {
  final List<RecipeModel> recipes;
  final Set<String> favoriteIds;

  const FavoriteRecipesLoaded({
    required this.recipes,
    required this.favoriteIds,
  });

  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  FavoriteRecipesLoaded copyWith({
    List<RecipeModel>? recipes,
    Set<String>? favoriteIds,
  }) {
    return FavoriteRecipesLoaded(
      recipes: recipes ?? this.recipes,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }

  @override
  List<Object?> get props => [recipes, favoriteIds];
}

/// Empty state (no favorites)
class FavoriteRecipesEmpty extends FavoritesState {
  const FavoriteRecipesEmpty();
}

/// Error state
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
