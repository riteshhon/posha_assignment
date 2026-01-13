import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:posha/core/constants/api_constants.dart';
import 'package:posha/data/models/recipe_model.dart';

/// Recipe Repository
/// Handles all API calls to TheMealDB
class RecipeRepository {
  final http.Client _client;

  RecipeRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Search recipes by name
  /// Example: searchByName('chicken')
  Future<List<RecipeModel>> searchByName(String query) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.searchByName,
      ).replace(queryParameters: {ApiConstants.paramSearch: query});

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final recipeResponse = RecipeResponse.fromJson(jsonData);
        return recipeResponse.meals;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching recipes: $e');
    }
  }

  /// Filter recipes by area
  /// Example: filterByArea('Canadian')
  Future<List<RecipeSummaryModel>> filterByArea(String area) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.filterByArea,
      ).replace(queryParameters: {ApiConstants.paramArea: area});

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final recipeResponse = RecipeSummaryResponse.fromJson(jsonData);
        return recipeResponse.meals;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering by area: $e');
    }
  }

  /// Get full recipe details by ID
  /// Example: getRecipeById('52772')
  Future<RecipeModel?> getRecipeById(String id) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.lookupById,
      ).replace(queryParameters: {ApiConstants.paramId: id});

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final recipeResponse = RecipeResponse.fromJson(jsonData);
        return recipeResponse.meals.isNotEmpty
            ? recipeResponse.meals.first
            : null;
      } else {
        throw Exception('Failed to load recipe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting recipe: $e');
    }
  }

  /// Get all categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.categories);

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final categoryResponse = CategoryResponse.fromJson(jsonData);
        return categoryResponse.categories;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting categories: $e');
    }
  }

  /// Get all areas
  Future<List<AreaModel>> getAreas() async {
    try {
      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.listAreas)
          .replace(
            queryParameters: {ApiConstants.paramArea: ApiConstants.paramList},
          );

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final areaResponse = AreaResponse.fromJson(jsonData);
        return areaResponse.meals;
      } else {
        throw Exception('Failed to load areas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting areas: $e');
    }
  }

  /// Filter recipes by category
  /// Example: filterByCategory('Seafood')
  Future<List<RecipeSummaryModel>> filterByCategory(String category) async {
    try {
      final uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.filterByCategory,
      ).replace(queryParameters: {ApiConstants.paramCategory: category});

      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final recipeResponse = RecipeSummaryResponse.fromJson(jsonData);
        return recipeResponse.meals;
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error filtering by category: $e');
    }
  }

  /// Get full recipe details from summary (fetches complete details by ID)
  /// Uses parallel requests for better performance
  Future<List<RecipeModel>> getFullRecipesFromSummaries(
    List<RecipeSummaryModel> summaries,
  ) async {
    try {
      // Fetch all recipes in parallel for better performance
      final futures = summaries.map((summary) => getRecipeById(summary.id));
      final results = await Future.wait(futures);

      // Filter out null values and return the list
      return results.whereType<RecipeModel>().toList();
    } catch (e) {
      throw Exception('Error getting full recipes: $e');
    }
  }
}
