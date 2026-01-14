import 'package:flutter/material.dart';
import 'package:posha/core/constants/app_strings.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/screens/home/home.dart';
import 'package:posha/screens/recipe_list/recipe_list.dart';
import 'package:posha/screens/recipe_favourite/recipe_favourite.dart';
import 'package:posha/screens/recipe_details/recipe_details.dart';

/// App Route Names
/// Centralized route name constants
class AppRoutes {
  AppRoutes._(); // Private constructor to prevent instantiation

  static const String home = '/';
  static const String recipeList = '/recipe-list';
  static const String recipeFavourite = '/recipe-favourite';
  static const String recipeDetails = '/recipe-details';
}

/// Route Generator
/// Handles navigation and route generation
class AppRouteGenerator {
  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.recipeList:
        return MaterialPageRoute(
          builder: (_) => const RecipeListScreen(),
          settings: settings,
        );

      case AppRoutes.recipeFavourite:
        return MaterialPageRoute(
          builder: (_) => const RecipeFavouriteScreen(),
          settings: settings,
        );

      case AppRoutes.recipeDetails:
        // Handle arguments if needed
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (context) => RecipeDetailsScreen(
              recipeId: args['recipeId'] as String?,
              recipe: args['recipe'] as RecipeModel?,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) => const RecipeDetailsScreen(),
          settings: settings,
        );

      default:
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text(AppStrings.pageNotFound)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) => Column(
                      children: [
                        Text(
                          AppStrings.pageNotFound,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Route: ${settings.name}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
