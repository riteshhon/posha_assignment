import 'package:equatable/equatable.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Recipe Details Events
abstract class RecipeDetailsEvent extends Equatable {
  const RecipeDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize recipe details
class RecipeDetailsInitialized extends RecipeDetailsEvent {
  final String? recipeId;
  final RecipeModel? recipe;

  const RecipeDetailsInitialized({
    this.recipeId,
    this.recipe,
  });

  @override
  List<Object?> get props => [recipeId, recipe];
}

/// Refresh recipe details
class RecipeDetailsRefreshed extends RecipeDetailsEvent {
  const RecipeDetailsRefreshed();
}

