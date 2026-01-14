import 'package:equatable/equatable.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Recipe Details States
abstract class RecipeDetailsState extends Equatable {
  const RecipeDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class RecipeDetailsInitial extends RecipeDetailsState {
  const RecipeDetailsInitial();
}

/// Loading state
class RecipeDetailsLoading extends RecipeDetailsState {
  const RecipeDetailsLoading();
}

/// Loaded state
class RecipeDetailsLoaded extends RecipeDetailsState {
  final RecipeModel recipe;

  const RecipeDetailsLoaded(this.recipe);

  @override
  List<Object?> get props => [recipe];
}

/// Error state
class RecipeDetailsError extends RecipeDetailsState {
  final String message;

  const RecipeDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

