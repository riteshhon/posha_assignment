import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posha/core/services/favorites_service.dart';
import 'package:posha/screens/recipe_favourite/bloc/favorites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favorites_state.dart';

/// Favorites BLoC
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesInitial()) {
    on<FavoritesInitialized>(_onInitialized);
    on<FavoriteToggled>(_onToggled);
    on<FavoriteAdded>(_onAdded);
    on<FavoriteRemoved>(_onRemoved);
  }

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

  Future<void> _onToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final isFav = currentState.isFavorite(event.recipeId);

      try {
        final success = await FavoritesService.toggleFavorite(event.recipeId);
        if (success) {
          final updatedIds = Set<String>.from(currentState.favoriteIds);
          if (isFav) {
            updatedIds.remove(event.recipeId);
          } else {
            updatedIds.add(event.recipeId);
          }
          emit(FavoritesLoaded(updatedIds));
        }
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    }
  }

  Future<void> _onAdded(
    FavoriteAdded event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      try {
        final success = await FavoritesService.addFavorite(event.recipeId);
        if (success) {
          final updatedIds = Set<String>.from(currentState.favoriteIds)
            ..add(event.recipeId);
          emit(FavoritesLoaded(updatedIds));
        }
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    }
  }

  Future<void> _onRemoved(
    FavoriteRemoved event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      try {
        final success = await FavoritesService.removeFavorite(event.recipeId);
        if (success) {
          final updatedIds = Set<String>.from(currentState.favoriteIds)
            ..remove(event.recipeId);
          emit(FavoritesLoaded(updatedIds));
        }
      } catch (e) {
        emit(FavoritesError(e.toString()));
      }
    }
  }
}
