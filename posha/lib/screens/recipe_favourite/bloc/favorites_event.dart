import 'package:equatable/equatable.dart';

/// Favorites Events
abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize favorites from storage
class FavoritesInitialized extends FavoritesEvent {
  const FavoritesInitialized();
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

