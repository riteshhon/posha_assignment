import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/data/repository/recipe_repository.dart';

import 'recipe_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late RecipeRepository repository;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    repository = RecipeRepository(client: mockClient);
  });

  group('RecipeRepository - searchByName', () {
    test('should return list of recipes when API call is successful', () async {
      // Arrange
      final jsonResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strCategory': 'Chicken',
            'strArea': 'Japanese',
            'strIngredient1': 'soy sauce',
            'strMeasure1': '3/4 cup',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.searchByName('chicken');

      // Assert
      expect(result, isA<List<RecipeModel>>());
      expect(result.length, 1);
      expect(result.first.id, '52772');
      expect(result.first.name, 'Teriyaki Chicken Casserole');
      verify(mockClient.get(any)).called(1);
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 404),
      );

      // Act & Assert
      expect(
        () => repository.searchByName('chicken'),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when network error occurs', () async {
      // Arrange
      when(mockClient.get(any)).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => repository.searchByName('chicken'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - getRecipeById', () {
    test('should return recipe when API call is successful', () async {
      // Arrange
      final jsonResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strCategory': 'Chicken',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.getRecipeById('52772');

      // Assert
      expect(result, isNotNull);
      expect(result?.id, '52772');
      expect(result?.name, 'Teriyaki Chicken Casserole');
    });

    test('should return null when recipe not found', () async {
      // Arrange
      final jsonResponse = {'meals': null};

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.getRecipeById('99999');

      // Assert
      expect(result, isNull);
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      // Act & Assert
      expect(
        () => repository.getRecipeById('52772'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - filterByArea', () {
    test('should return list of recipe summaries when API call is successful',
        () async {
      // Arrange
      final jsonResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strMealThumb': 'https://example.com/image.jpg',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.filterByArea('Japanese');

      // Assert
      expect(result, isA<List<RecipeSummaryModel>>());
      expect(result.length, 1);
      expect(result.first.id, '52772');
      expect(result.first.name, 'Teriyaki Chicken Casserole');
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 404),
      );

      // Act & Assert
      expect(
        () => repository.filterByArea('Japanese'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - filterByCategory', () {
    test('should return list of recipe summaries when API call is successful',
        () async {
      // Arrange
      final jsonResponse = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Teriyaki Chicken Casserole',
            'strMealThumb': 'https://example.com/image.jpg',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.filterByCategory('Chicken');

      // Assert
      expect(result, isA<List<RecipeSummaryModel>>());
      expect(result.length, 1);
      expect(result.first.id, '52772');
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 404),
      );

      // Act & Assert
      expect(
        () => repository.filterByCategory('Chicken'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - getCategories', () {
    test('should return list of categories when API call is successful',
        () async {
      // Arrange
      final jsonResponse = {
        'categories': [
          {
            'idCategory': '1',
            'strCategory': 'Chicken',
            'strCategoryThumb': 'https://example.com/chicken.png',
            'strCategoryDescription': 'Chicken recipes',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.getCategories();

      // Assert
      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Chicken');
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      // Act & Assert
      expect(
        () => repository.getCategories(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - getAreas', () {
    test('should return list of areas when API call is successful', () async {
      // Arrange
      final jsonResponse = {
        'meals': [
          {'strArea': 'Japanese'},
          {'strArea': 'American'},
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode(jsonResponse),
          200,
        ),
      );

      // Act
      final result = await repository.getAreas();

      // Assert
      expect(result, isA<List<AreaModel>>());
      expect(result.length, 2);
      expect(result.first.name, 'Japanese');
      expect(result.last.name, 'American');
    });

    test('should throw exception when API call fails', () async {
      // Arrange
      when(mockClient.get(any)).thenAnswer(
        (_) async => http.Response('Error', 500),
      );

      // Act & Assert
      expect(
        () => repository.getAreas(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('RecipeRepository - getFullRecipesFromSummaries', () {
    test('should return full recipes from summaries', () async {
      // Arrange
      final summaries = [
        const RecipeSummaryModel(id: '52772', name: 'Recipe 1'),
        const RecipeSummaryModel(id: '52773', name: 'Recipe 2'),
      ];

      final jsonResponse1 = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Recipe 1',
            'strCategory': 'Chicken',
          },
        ],
      };

      final jsonResponse2 = {
        'meals': [
          {
            'idMeal': '52773',
            'strMeal': 'Recipe 2',
            'strCategory': 'Beef',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (invocation) async {
          final uri = invocation.positionalArguments[0] as Uri;
          if (uri.queryParameters['i'] == '52772') {
            return http.Response(json.encode(jsonResponse1), 200);
          } else {
            return http.Response(json.encode(jsonResponse2), 200);
          }
        },
      );

      // Act
      final result = await repository.getFullRecipesFromSummaries(summaries);

      // Assert
      expect(result, isA<List<RecipeModel>>());
      expect(result.length, 2);
      expect(result.first.id, '52772');
      expect(result.last.id, '52773');
    });

    test('should filter out null results', () async {
      // Arrange
      final summaries = [
        const RecipeSummaryModel(id: '52772', name: 'Recipe 1'),
        const RecipeSummaryModel(id: '99999', name: 'Recipe 2'),
      ];

      final jsonResponse1 = {
        'meals': [
          {
            'idMeal': '52772',
            'strMeal': 'Recipe 1',
            'strCategory': 'Chicken',
          },
        ],
      };

      when(mockClient.get(any)).thenAnswer(
        (invocation) async {
          final uri = invocation.positionalArguments[0] as Uri;
          if (uri.queryParameters['i'] == '52772') {
            return http.Response(json.encode(jsonResponse1), 200);
          } else {
            return http.Response(json.encode({'meals': null}), 200);
          }
        },
      );

      // Act
      final result = await repository.getFullRecipesFromSummaries(summaries);

      // Assert
      expect(result.length, 1);
      expect(result.first.id, '52772');
    });
  });
}

