import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_details/bloc/recipe_details_event.dart';
import 'package:posha/screens/recipe_details/bloc/recipe_details_state.dart';

/// Recipe Details BLoC
class RecipeDetailsBloc extends Bloc<RecipeDetailsEvent, RecipeDetailsState> {
  final RecipeRepository _repository;

  RecipeDetailsBloc({required RecipeRepository repository})
      : _repository = repository,
        super(const RecipeDetailsInitial()) {
    on<RecipeDetailsInitialized>(_onInitialized);
    on<RecipeDetailsRefreshed>(_onRefreshed);
  }

  Future<void> _onInitialized(
    RecipeDetailsInitialized event,
    Emitter<RecipeDetailsState> emit,
  ) async {
    // If recipe is already provided, use it directly
    if (event.recipe != null) {
      emit(RecipeDetailsLoaded(event.recipe!));
      return;
    }

    // Otherwise, fetch from API
    if (event.recipeId == null || event.recipeId!.isEmpty) {
      emit(const RecipeDetailsError('Recipe ID is required'));
      return;
    }

    emit(const RecipeDetailsLoading());

    try {
      final recipe = await _repository.getRecipeById(event.recipeId!);
      if (recipe == null) {
        emit(const RecipeDetailsError('Recipe not found'));
      } else {
        emit(RecipeDetailsLoaded(recipe));
      }
    } catch (e) {
      emit(RecipeDetailsError(e.toString()));
    }
  }

  Future<void> _onRefreshed(
    RecipeDetailsRefreshed event,
    Emitter<RecipeDetailsState> emit,
  ) async {
    if (state is RecipeDetailsLoaded) {
      final currentState = state as RecipeDetailsLoaded;
      add(RecipeDetailsInitialized(recipeId: currentState.recipe.id));
    }
  }
}

