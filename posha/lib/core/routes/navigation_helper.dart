import 'package:flutter/material.dart';
import 'package:posha/core/routes/app_routes.dart';

/// Navigation Helper
/// Provides convenient methods for navigation throughout the app
class NavigationHelper {
  NavigationHelper._(); // Private constructor to prevent instantiation

  /// Navigate to a route by name
  static Future<T?>? pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a route and replace current route
  static Future<T?>? pushReplacementNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, T>(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a route and remove all previous routes
  static Future<T?>? pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current route
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Navigate to Home Screen
  static Future<T?>? toHome<T>(BuildContext context) {
    return pushNamedAndRemoveUntil<T>(context, AppRoutes.home);
  }

  /// Navigate to Recipe List Screen
  static Future<T?>? toRecipeList<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.recipeList);
  }

  /// Navigate to Recipe Favourite Screen
  static Future<T?>? toRecipeFavourite<T>(BuildContext context) {
    return pushNamed<T>(context, AppRoutes.recipeFavourite);
  }

  /// Navigate to Recipe Details Screen
  static Future<T?>? toRecipeDetails<T>(
    BuildContext context, {
    String? recipeId,
    dynamic recipe,
  }) {
    return pushNamed<T>(
      context,
      AppRoutes.recipeDetails,
      arguments: {
        'recipeId': recipeId,
        'recipe': recipe,
      },
    );
  }
}

