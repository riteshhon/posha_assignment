import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Service for managing favorite recipes persistence
class FavoritesService {
  static const String _favoritesKey = 'favorite_recipes';

  /// Get all favorite recipe IDs
  static Future<Set<String>> getFavoriteIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson == null) return <String>{};

      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.map((id) => id.toString()).toSet();
    } catch (e) {
      return <String>{};
    }
  }

  /// Check if a recipe is favorited
  static Future<bool> isFavorite(String recipeId) async {
    final favorites = await getFavoriteIds();
    return favorites.contains(recipeId);
  }

  /// Add recipe to favorites
  static Future<bool> addFavorite(String recipeId) async {
    try {
      final favorites = await getFavoriteIds();
      favorites.add(recipeId);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  /// Remove recipe from favorites
  static Future<bool> removeFavorite(String recipeId) async {
    try {
      final favorites = await getFavoriteIds();
      favorites.remove(recipeId);
      return await _saveFavorites(favorites);
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

  /// Save favorites to SharedPreferences
  static Future<bool> _saveFavorites(Set<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favorites.toList());
      return await prefs.setString(_favoritesKey, favoritesJson);
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
}

