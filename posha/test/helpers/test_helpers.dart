import 'package:hive/hive.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Test Helper Utilities
/// Provides common setup and utilities for tests
class TestHelpers {
  /// Initialize Hive for testing
  /// Should be called in setUpAll() for tests that use Hive
  static Future<void> initHiveForTesting() async {
    try {
      Hive.init('test/hive_test');
    } catch (e) {
      // Hive might already be initialized
    }
  }

  /// Clean up Hive boxes after tests
  /// Should be called in tearDown() or tearDownAll()
  /// This method is defensive and will not fail if boxes are locked
  static Future<void> cleanupHive() async {
    try {
      // Try to close the box if it's already open
      if (Hive.isBoxOpen('favorites')) {
        try {
          final box = Hive.box('favorites');
          await box.clear();
          await box.close();
          return; // Successfully cleaned up
        } catch (e) {
          // Box might be in use, just try to close it
          try {
            if (Hive.isBoxOpen('favorites')) {
              await Hive.box('favorites').close();
            }
          } catch (_) {
            // Ignore close errors - box might be locked
          }
          return; // Attempted cleanup, exit gracefully
        }
      }
      
      // Box is not open, check if it exists
      if (await Hive.boxExists('favorites')) {
        // Try to open with timeout and retry logic
        bool opened = false;
        for (int attempt = 0; attempt < 3; attempt++) {
          try {
            if (attempt > 0) {
              // Wait before retry
              await Future.delayed(Duration(milliseconds: 50 * (attempt + 1)));
            }
            // Check if box is now open (might have been opened by another test)
            if (Hive.isBoxOpen('favorites')) {
              try {
                final box = Hive.box('favorites');
                await box.clear();
                await box.close();
                opened = true;
                break;
              } catch (_) {
                // Can't access box, skip
                break;
              }
            }
            // Try to open the box
            final box = await Hive.openBox('favorites');
            await box.clear();
            await box.close();
            opened = true;
            break;
          } catch (e) {
            // Lock conflict or other error
            if (attempt == 2) {
              // Last attempt failed, just give up
              // This is OK - the next test will handle cleanup
              break;
            }
          }
        }
        // If we couldn't open it, that's fine - skip cleanup
        // This prevents test failures due to parallel execution
      }
    } catch (e) {
      // Ignore all cleanup errors (lock file issues, etc.)
      // This can happen when tests run in parallel or boxes are in use
      // It's safe to ignore - tests will handle their own cleanup
    }
  }

  /// Create a test recipe model
  static const testRecipe = RecipeModel(
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

  /// Create a test recipe summary model
  static const testRecipeSummary = RecipeSummaryModel(
    id: '52772',
    name: 'Teriyaki Chicken Casserole',
    thumbnail: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
  );

  /// Create a test category model
  static const testCategory = CategoryModel(
    id: '1',
    name: 'Chicken',
    thumbnail: 'https://www.themealdb.com/images/category/chicken.png',
    description: 'Chicken recipes',
  );

  /// Create a test area model
  static const testArea = AreaModel(name: 'Japanese');
}
