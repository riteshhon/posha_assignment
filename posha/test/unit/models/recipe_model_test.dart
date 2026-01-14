import 'package:flutter_test/flutter_test.dart';
import 'package:posha/data/models/recipe_model.dart';

void main() {
  group('RecipeModel', () {
    test('should create RecipeModel from JSON correctly', () {
      // Arrange
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strInstructions': 'Preheat oven to 350° F...',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
        'strIngredient1': 'soy sauce',
        'strIngredient2': 'water',
        'strIngredient3': 'brown sugar',
        'strMeasure1': '3/4 cup',
        'strMeasure2': '1/2 cup',
        'strMeasure3': '1/4 cup',
      };

      // Act
      final recipe = RecipeModel.fromJson(json);

      // Assert
      expect(recipe.id, '52772');
      expect(recipe.name, 'Teriyaki Chicken Casserole');
      expect(recipe.category, 'Chicken');
      expect(recipe.area, 'Japanese');
      expect(recipe.instructions, 'Preheat oven to 350° F...');
      expect(recipe.thumbnail, 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg');
      expect(recipe.youtubeUrl, 'https://www.youtube.com/watch?v=4aZr5hZXP_s');
      expect(recipe.ingredients.length, 3);
      expect(recipe.ingredients[0], 'soy sauce');
      expect(recipe.ingredients[1], 'water');
      expect(recipe.ingredients[2], 'brown sugar');
      expect(recipe.measures.length, 3);
      expect(recipe.measures[0], '3/4 cup');
      expect(recipe.measures[1], '1/2 cup');
      expect(recipe.measures[2], '1/4 cup');
    });

    test('should handle null and empty values in JSON', () {
      // Arrange
      final json = {
        'idMeal': '52772',
        'strMeal': 'Test Recipe',
        'strCategory': '',
        'strArea': null,
        'strInstructions': '',
        'strMealThumb': null,
        'strYoutube': '',
      };

      // Act
      final recipe = RecipeModel.fromJson(json);

      // Assert
      expect(recipe.id, '52772');
      expect(recipe.name, 'Test Recipe');
      expect(recipe.category, isNull);
      expect(recipe.area, isNull);
      expect(recipe.instructions, isNull);
      expect(recipe.thumbnail, isNull);
      expect(recipe.youtubeUrl, isNull);
      expect(recipe.ingredients, isEmpty);
      expect(recipe.measures, isEmpty);
    });

    test('should convert RecipeModel to JSON correctly', () {
      // Arrange
      const recipe = RecipeModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        category: 'Chicken',
        area: 'Japanese',
        instructions: 'Preheat oven to 350° F...',
        thumbnail: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        youtubeUrl: 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
        ingredients: ['soy sauce', 'water', 'brown sugar'],
        measures: ['3/4 cup', '1/2 cup', '1/4 cup'],
      );

      // Act
      final json = recipe.toJson();

      // Assert
      expect(json['idMeal'], '52772');
      expect(json['strMeal'], 'Teriyaki Chicken Casserole');
      expect(json['strCategory'], 'Chicken');
      expect(json['strArea'], 'Japanese');
      expect(json['strInstructions'], 'Preheat oven to 350° F...');
      expect(json['strMealThumb'], 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg');
      expect(json['strYoutube'], 'https://www.youtube.com/watch?v=4aZr5hZXP_s');
      expect(json['strIngredient1'], 'soy sauce');
      expect(json['strIngredient2'], 'water');
      expect(json['strIngredient3'], 'brown sugar');
      expect(json['strMeasure1'], '3/4 cup');
      expect(json['strMeasure2'], '1/2 cup');
      expect(json['strMeasure3'], '1/4 cup');
    });

    test('should handle Equatable correctly', () {
      // Arrange
      const recipe1 = RecipeModel(
        id: '52772',
        name: 'Test Recipe',
        category: 'Chicken',
        ingredients: ['ingredient1'],
        measures: ['measure1'],
      );

      const recipe2 = RecipeModel(
        id: '52772',
        name: 'Test Recipe',
        category: 'Chicken',
        ingredients: ['ingredient1'],
        measures: ['measure1'],
      );

      const recipe3 = RecipeModel(
        id: '52773',
        name: 'Different Recipe',
        category: 'Beef',
        ingredients: ['ingredient2'],
        measures: ['measure2'],
      );

      // Assert
      expect(recipe1, equals(recipe2));
      expect(recipe1, isNot(equals(recipe3)));
      expect(recipe1.hashCode, equals(recipe2.hashCode));
    });
  });

  group('RecipeSummaryModel', () {
    test('should create RecipeSummaryModel from JSON correctly', () {
      // Arrange
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
      };

      // Act
      final summary = RecipeSummaryModel.fromJson(json);

      // Assert
      expect(summary.id, '52772');
      expect(summary.name, 'Teriyaki Chicken Casserole');
      expect(summary.thumbnail, 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg');
    });

    test('should convert RecipeSummaryModel to JSON correctly', () {
      // Arrange
      const summary = RecipeSummaryModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        thumbnail: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
      );

      // Act
      final json = summary.toJson();

      // Assert
      expect(json['idMeal'], '52772');
      expect(json['strMeal'], 'Teriyaki Chicken Casserole');
      expect(json['strMealThumb'], 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg');
    });
  });

  group('CategoryModel', () {
    test('should create CategoryModel from JSON correctly', () {
      // Arrange
      final json = {
        'idCategory': '1',
        'strCategory': 'Chicken',
        'strCategoryThumb': 'https://www.themealdb.com/images/category/chicken.png',
        'strCategoryDescription': 'Chicken is a type of poultry...',
      };

      // Act
      final category = CategoryModel.fromJson(json);

      // Assert
      expect(category.id, '1');
      expect(category.name, 'Chicken');
      expect(category.thumbnail, 'https://www.themealdb.com/images/category/chicken.png');
      expect(category.description, 'Chicken is a type of poultry...');
    });

    test('should convert CategoryModel to JSON correctly', () {
      // Arrange
      const category = CategoryModel(
        id: '1',
        name: 'Chicken',
        thumbnail: 'https://www.themealdb.com/images/category/chicken.png',
        description: 'Chicken is a type of poultry...',
      );

      // Act
      final json = category.toJson();

      // Assert
      expect(json['idCategory'], '1');
      expect(json['strCategory'], 'Chicken');
      expect(json['strCategoryThumb'], 'https://www.themealdb.com/images/category/chicken.png');
      expect(json['strCategoryDescription'], 'Chicken is a type of poultry...');
    });
  });

  group('AreaModel', () {
    test('should create AreaModel from JSON correctly', () {
      // Arrange
      final json = {
        'strArea': 'Japanese',
      };

      // Act
      final area = AreaModel.fromJson(json);

      // Assert
      expect(area.name, 'Japanese');
    });

    test('should convert AreaModel to JSON correctly', () {
      // Arrange
      const area = AreaModel(name: 'Japanese');

      // Act
      final json = area.toJson();

      // Assert
      expect(json['strArea'], 'Japanese');
    });
  });

  group('Response Models', () {
    test('RecipeResponse should parse JSON correctly', () {
      // Arrange
      final json = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strCategory': 'Chicken',
          },
        ],
      };

      // Act
      final response = RecipeResponse.fromJson(json);

      // Assert
      expect(response.meals.length, 1);
      expect(response.meals.first.id, '52772');
      expect(response.meals.first.name, 'Teriyaki Chicken Casserole');
    });

    test('RecipeResponse should handle empty meals array', () {
      // Arrange
      final json = {'meals': null};

      // Act
      final response = RecipeResponse.fromJson(json);

      // Assert
      expect(response.meals, isEmpty);
    });

    test('RecipeSummaryResponse should parse JSON correctly', () {
      // Arrange
      final json = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
          },
        ],
      };

      // Act
      final response = RecipeSummaryResponse.fromJson(json);

      // Assert
      expect(response.meals.length, 1);
      expect(response.meals.first.id, '52772');
    });

    test('CategoryResponse should parse JSON correctly', () {
      // Arrange
      final json = {
        'categories': [
          {
            'idCategory': '1',
            'strCategory': 'Chicken',
          },
        ],
      };

      // Act
      final response = CategoryResponse.fromJson(json);

      // Assert
      expect(response.categories.length, 1);
      expect(response.categories.first.name, 'Chicken');
    });

    test('AreaResponse should parse JSON correctly', () {
      // Arrange
      final json = {
        'meals': [
          {'strArea': 'Japanese'},
          {'strArea': 'American'},
        ],
      };

      // Act
      final response = AreaResponse.fromJson(json);

      // Assert
      expect(response.meals.length, 2);
      expect(response.meals.first.name, 'Japanese');
      expect(response.meals.last.name, 'American');
    });
  });
}

