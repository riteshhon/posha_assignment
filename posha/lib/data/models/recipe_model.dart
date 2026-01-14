import 'package:equatable/equatable.dart';

/// JSON parsing utility helper
class _JsonHelper {
  /// Safely extract string values from JSON, returning null for empty strings
  static String? getStringOrNull(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is String) {
      return value.isEmpty ? null : value;
    }
    return value.toString();
  }
}

/// Recipe Model - Full recipe details with ingredients and instructions
class RecipeModel extends Equatable {
  final String id;
  final String name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? thumbnail;
  final String? youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  const RecipeModel({
    required this.id,
    required this.name,
    this.category,
    this.area,
    this.instructions,
    this.thumbnail,
    this.youtubeUrl,
    this.ingredients = const [],
    this.measures = const [],
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];
    final measures = <String>[];

    // Extract ingredients and measures (strIngredient1, strMeasure1, etc.)
    for (int i = 1; i <= 20; i++) {
      final ingredient = _JsonHelper.getStringOrNull(json, 'strIngredient$i');
      final measure = _JsonHelper.getStringOrNull(json, 'strMeasure$i');

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient.trim());
        measures.add(measure?.trim() ?? '');
      }
    }

    return RecipeModel(
      id: _JsonHelper.getStringOrNull(json, 'idMeal') ?? '',
      name: _JsonHelper.getStringOrNull(json, 'strMeal') ?? '',
      category: _JsonHelper.getStringOrNull(json, 'strCategory'),
      area: _JsonHelper.getStringOrNull(json, 'strArea'),
      instructions: _JsonHelper.getStringOrNull(json, 'strInstructions'),
      thumbnail: _JsonHelper.getStringOrNull(json, 'strMealThumb'),
      youtubeUrl: _JsonHelper.getStringOrNull(json, 'strYoutube'),
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      if (category != null) 'strCategory': category,
      if (area != null) 'strArea': area,
      if (instructions != null) 'strInstructions': instructions,
      if (thumbnail != null) 'strMealThumb': thumbnail,
      if (youtubeUrl != null) 'strYoutube': youtubeUrl,
    };

    // Add ingredients and measures
    for (int i = 0; i < ingredients.length; i++) {
      json['strIngredient${i + 1}'] = ingredients[i];
      if (i < measures.length && measures[i].isNotEmpty) {
        json['strMeasure${i + 1}'] = measures[i];
      }
    }

    return json;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    area,
    instructions,
    thumbnail,
    youtubeUrl,
    ingredients,
    measures,
  ];
}

/// Recipe Summary Model - Lightweight model for list/filter responses
class RecipeSummaryModel extends Equatable {
  final String id;
  final String name;
  final String? thumbnail;

  const RecipeSummaryModel({
    required this.id,
    required this.name,
    this.thumbnail,
  });

  factory RecipeSummaryModel.fromJson(Map<String, dynamic> json) {
    return RecipeSummaryModel(
      id: _JsonHelper.getStringOrNull(json, 'idMeal') ?? '',
      name: _JsonHelper.getStringOrNull(json, 'strMeal') ?? '',
      thumbnail: _JsonHelper.getStringOrNull(json, 'strMealThumb'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      if (thumbnail != null) 'strMealThumb': thumbnail,
    };
  }

  @override
  List<Object?> get props => [id, name, thumbnail];
}

/// Category Model - Recipe category information
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String? thumbnail;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    this.thumbnail,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: _JsonHelper.getStringOrNull(json, 'idCategory') ?? '',
      name: _JsonHelper.getStringOrNull(json, 'strCategory') ?? '',
      thumbnail: _JsonHelper.getStringOrNull(json, 'strCategoryThumb'),
      description: _JsonHelper.getStringOrNull(json, 'strCategoryDescription'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': id,
      'strCategory': name,
      if (thumbnail != null) 'strCategoryThumb': thumbnail,
      if (description != null) 'strCategoryDescription': description,
    };
  }

  @override
  List<Object?> get props => [id, name, thumbnail, description];
}

/// Area Model - Cuisine/area information
class AreaModel extends Equatable {
  final String name;

  const AreaModel({required this.name});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(name: _JsonHelper.getStringOrNull(json, 'strArea') ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'strArea': name};
  }

  @override
  List<Object?> get props => [name];
}

// ============================================================================
// API Response Models
// ============================================================================

/// Recipe Response - Wrapper for recipe search/lookup responses
class RecipeResponse {
  final List<RecipeModel> meals;

  const RecipeResponse({required this.meals});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    final mealsList = json['meals'] as List<dynamic>?;
    if (mealsList == null || mealsList.isEmpty) {
      return const RecipeResponse(meals: []);
    }

    return RecipeResponse(
      meals: mealsList
          .whereType<Map<String, dynamic>>()
          .map((meal) => RecipeModel.fromJson(meal))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'meals': meals.map((meal) => meal.toJson()).toList()};
  }
}

/// Recipe Summary Response - Wrapper for filter responses
class RecipeSummaryResponse {
  final List<RecipeSummaryModel> meals;

  const RecipeSummaryResponse({required this.meals});

  factory RecipeSummaryResponse.fromJson(Map<String, dynamic> json) {
    final mealsList = json['meals'] as List<dynamic>?;
    if (mealsList == null || mealsList.isEmpty) {
      return const RecipeSummaryResponse(meals: []);
    }

    return RecipeSummaryResponse(
      meals: mealsList
          .whereType<Map<String, dynamic>>()
          .map((meal) => RecipeSummaryModel.fromJson(meal))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'meals': meals.map((meal) => meal.toJson()).toList()};
  }
}

/// Category Response - Wrapper for categories list response
class CategoryResponse {
  final List<CategoryModel> categories;

  const CategoryResponse({required this.categories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final categoriesList = json['categories'] as List<dynamic>?;
    if (categoriesList == null || categoriesList.isEmpty) {
      return const CategoryResponse(categories: []);
    }

    return CategoryResponse(
      categories: categoriesList
          .whereType<Map<String, dynamic>>()
          .map((category) => CategoryModel.fromJson(category))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}

/// Area Response - Wrapper for areas list response
class AreaResponse {
  final List<AreaModel> meals;

  const AreaResponse({required this.meals});

  factory AreaResponse.fromJson(Map<String, dynamic> json) {
    final mealsList = json['meals'] as List<dynamic>?;
    if (mealsList == null || mealsList.isEmpty) {
      return const AreaResponse(meals: []);
    }

    return AreaResponse(
      meals: mealsList
          .whereType<Map<String, dynamic>>()
          .map((area) => AreaModel.fromJson(area))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'meals': meals.map((area) => area.toJson()).toList()};
  }
}
