import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:posha/core/services/favorites_service.dart';
import 'package:posha/data/models/recipe_model.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('FavoritesService', () {
    setUpAll(() async {
      // Initialize Hive for testing
      await TestHelpers.initHiveForTesting();
    });

    setUp(() async {
      // Ensure box is closed before each test to avoid lock issues
      // Don't try to open it - just close if open and clear if possible
      try {
        if (Hive.isBoxOpen('favorites')) {
          try {
            final box = Hive.box('favorites');
            await box.clear();
            await box.close();
          } catch (e) {
            // If clear/close fails, just try to close
            try {
              if (Hive.isBoxOpen('favorites')) {
                await Hive.box('favorites').close();
              }
            } catch (_) {
              // Ignore - box might be locked, will be handled by test
            }
          }
        }
        // Small delay to ensure lock is released
        await Future.delayed(const Duration(milliseconds: 20));
      } catch (e) {
        // Ignore - box might be locked from previous test
        // The test will handle opening it via FavoritesService.init()
      }
    });

    tearDown(() async {
      // Clean up after each test
      await TestHelpers.cleanupHive();
      // Ensure box is closed
      try {
        if (Hive.isBoxOpen('favorites')) {
          await Hive.box('favorites').close();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
    });

    tearDownAll(() async {
      // Final cleanup after all tests in this group
      try {
        if (Hive.isBoxOpen('favorites')) {
          final box = Hive.box('favorites');
          await box.clear();
          await box.close();
        }
      } catch (e) {
        // Ignore final cleanup errors
      }
    });

    test('should initialize successfully', () async {
      // Act
      await FavoritesService.init();

      // Assert
      final favoriteIds = await FavoritesService.getFavoriteIds();
      expect(favoriteIds, isEmpty);
    });

    test('should add favorite recipe', () async {
      // Arrange
      await FavoritesService.init();
      const recipeId = '52772';

      // Act
      final result = await FavoritesService.addFavorite(recipeId);

      // Assert
      expect(result, isTrue);
      final isFav = await FavoritesService.isFavorite(recipeId);
      expect(isFav, isTrue);
      final favoriteIds = await FavoritesService.getFavoriteIds();
      expect(favoriteIds, contains(recipeId));
    });

    test('should remove favorite recipe', () async {
      // Arrange
      await FavoritesService.init();
      const recipeId = '52772';
      await FavoritesService.addFavorite(recipeId);

      // Act
      final result = await FavoritesService.removeFavorite(recipeId);

      // Assert
      expect(result, isTrue);
      final isFav = await FavoritesService.isFavorite(recipeId);
      expect(isFav, isFalse);
      final favoriteIds = await FavoritesService.getFavoriteIds();
      expect(favoriteIds, isNot(contains(recipeId)));
    });

    test('should toggle favorite status', () async {
      // Arrange
      await FavoritesService.init();
      const recipeId = '52772';

      // Act - Toggle on
      final result1 = await FavoritesService.toggleFavorite(recipeId);
      final isFav1 = await FavoritesService.isFavorite(recipeId);

      // Toggle off
      final result2 = await FavoritesService.toggleFavorite(recipeId);
      final isFav2 = await FavoritesService.isFavorite(recipeId);

      // Assert
      expect(result1, isTrue);
      expect(isFav1, isTrue);
      expect(result2, isTrue);
      expect(isFav2, isFalse);
    });

    test('should return correct favorite count', () async {
      // Arrange
      await FavoritesService.init();
      await FavoritesService.addFavorite('52772');
      await FavoritesService.addFavorite('52773');
      await FavoritesService.addFavorite('52774');

      // Act
      final count = await FavoritesService.getFavoriteCount();

      // Assert
      expect(count, 3);
    });

    test('should get favorite recipes from all recipes', () async {
      // Arrange
      await FavoritesService.init();
      const favoriteRecipe1 = RecipeModel(
        id: '52772',
        name: 'Recipe 1',
        ingredients: [],
        measures: [],
      );
      const favoriteRecipe2 = RecipeModel(
        id: '52773',
        name: 'Recipe 2',
        ingredients: [],
        measures: [],
      );
      const nonFavoriteRecipe = RecipeModel(
        id: '52774',
        name: 'Recipe 3',
        ingredients: [],
        measures: [],
      );

      await FavoritesService.addFavorite('52772');
      await FavoritesService.addFavorite('52773');

      final allRecipes = [
        favoriteRecipe1,
        favoriteRecipe2,
        nonFavoriteRecipe,
      ];

      // Act
      final favoriteRecipes =
          await FavoritesService.getFavoriteRecipes(allRecipes);

      // Assert
      expect(favoriteRecipes.length, 2);
      expect(favoriteRecipes.map((r) => r.id), containsAll(['52772', '52773']));
      expect(favoriteRecipes.map((r) => r.id), isNot(contains('52774')));
    });

    test('should clear all favorites', () async {
      // Arrange
      await FavoritesService.init();
      await FavoritesService.addFavorite('52772');
      await FavoritesService.addFavorite('52773');
      await FavoritesService.addFavorite('52774');

      // Act
      final result = await FavoritesService.clearAllFavorites();

      // Assert
      expect(result, isTrue);
      final count = await FavoritesService.getFavoriteCount();
      expect(count, 0);
      final favoriteIds = await FavoritesService.getFavoriteIds();
      expect(favoriteIds, isEmpty);
    });

    test('should return false when recipe is not favorite', () async {
      // Arrange
      await FavoritesService.init();
      const recipeId = '52772';

      // Act
      final isFav = await FavoritesService.isFavorite(recipeId);

      // Assert
      expect(isFav, isFalse);
    });

    test('should handle multiple favorites correctly', () async {
      // Arrange
      await FavoritesService.init();
      const recipeIds = ['52772', '52773', '52774', '52775'];

      // Act
      for (final id in recipeIds) {
        await FavoritesService.addFavorite(id);
      }

      // Assert
      final favoriteIds = await FavoritesService.getFavoriteIds();
      expect(favoriteIds.length, 4);
      for (final id in recipeIds) {
        expect(await FavoritesService.isFavorite(id), isTrue);
      }
    });
  });
}

