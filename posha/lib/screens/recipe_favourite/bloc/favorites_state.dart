import 'package:equatable/equatable.dart';

/// Favorites States
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Loaded state with favorite IDs
class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;

  const FavoritesLoaded(this.favoriteIds);

  bool isFavorite(String recipeId) => favoriteIds.contains(recipeId);

  FavoritesLoaded copyWith({
    Set<String>? favoriteIds,
  }) {
    return FavoritesLoaded(favoriteIds ?? this.favoriteIds);
  }

  @override
  List<Object?> get props => [favoriteIds];
}

/// Error state
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

