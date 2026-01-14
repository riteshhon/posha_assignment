import 'package:equatable/equatable.dart';

/// Unified Favorites Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize favorites (loads IDs only)
class FavoritesInitialized extends FavoritesEvent {
  const FavoritesInitialized();
}

/// Initialize and load full favorite recipes data
class FavoriteRecipesInitialized extends FavoritesEvent {
  const FavoriteRecipesInitialized();
}

/// Refresh favorite recipes list
class FavoriteRecipesRefreshed extends FavoritesEvent {
  const FavoriteRecipesRefreshed();
}

/// Toggle favorite status for a recipe
class FavoriteToggled extends FavoritesEvent {
  final String recipeId;

  const FavoriteToggled(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

/// Add recipe to favorites
class FavoriteAdded extends FavoritesEvent {
  final String recipeId;

  const FavoriteAdded(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}

/// Remove recipe from favorites
class FavoriteRemoved extends FavoritesEvent {
  final String recipeId;

  const FavoriteRemoved(this.recipeId);

  @override
  List<Object?> get props => [recipeId];
}
