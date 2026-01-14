import 'package:hive_flutter/hive_flutter.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Service for managing favorite recipes persistence using Hive
class FavoritesService {
  static const String _boxName = 'favorites';
  static Box? _box;
  static bool _initialized = false;

  /// Initialize Hive box for favorites
  static Future<void> init() async {
    if (_initialized && _box != null && _box!.isOpen) {
      return;
    }
    
    try {
      _box = await Hive.openBox(_boxName);
      _initialized = true;
    } catch (e) {
      // If there's an error, try to delete and recreate
      try {
        if (await Hive.boxExists(_boxName)) {
          await Hive.deleteBoxFromDisk(_boxName);
        }
      } catch (_) {
        // Ignore delete errors
      }
      _box = await Hive.openBox(_boxName);
      _initialized = true;
    }
  }

  /// Get the favorites box (initializes if needed)
  static Future<Box> _getBox() async {
    if (!_initialized || _box == null || !_box!.isOpen) {
      await init();
    }
    return _box!;
  }

  /// Get all favorite recipe IDs
  static Future<Set<String>> getFavoriteIds() async {
    try {
      final box = await _getBox();
      final ids = <String>{};
      // Get all keys from the box - keys are the recipe IDs
      for (var key in box.keys) {
        if (key is String) {
          ids.add(key);
        } else {
          final id = key.toString();
          if (id.isNotEmpty) {
            ids.add(id);
          }
        }
      }
      return ids;
    } catch (e) {
      return <String>{};
    }
  }

  /// Check if a recipe is favorited
  static Future<bool> isFavorite(String recipeId) async {
    try {
      final box = await _getBox();
      // Check if key exists (we store recipeId as key)
      return box.containsKey(recipeId);
    } catch (e) {
      return false;
    }
  }

  /// Add recipe to favorites
  static Future<bool> addFavorite(String recipeId) async {
    try {
      final box = await _getBox();
      // Store recipeId as key with boolean true as value
      await box.put(recipeId, true);
      // Ensure data is persisted
      await box.flush();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove recipe from favorites
  static Future<bool> removeFavorite(String recipeId) async {
    try {
      final box = await _getBox();
      await box.delete(recipeId);
      // Ensure data is persisted
      await box.flush();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Toggle favorite status
  static Future<bool> toggleFavorite(String recipeId) async {
    final isFav = await isFavorite(recipeId);
    return isFav
        ? await removeFavorite(recipeId)
        : await addFavorite(recipeId);
  }

  /// Clear all favorites
  static Future<bool> clearAllFavorites() async {
    try {
      final box = await _getBox();
      await box.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get all favorite recipes (requires recipe data)
  static Future<List<RecipeModel>> getFavoriteRecipes(
    List<RecipeModel> allRecipes,
  ) async {
    final favoriteIds = await getFavoriteIds();
    return allRecipes.where((recipe) => favoriteIds.contains(recipe.id)).toList();
  }

  /// Get count of favorites
  static Future<int> getFavoriteCount() async {
    try {
      final box = await _getBox();
      return box.length;
    } catch (e) {
      return 0;
    }
  }
}
