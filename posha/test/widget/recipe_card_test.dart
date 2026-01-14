import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/screens/recipe_list/widget/recipe_card.dart';

void main() {
  group('RecipeGridCard Widget Tests', () {
    const testRecipe = RecipeModel(
      id: '52772',
      name: 'Teriyaki Chicken Casserole',
      category: 'Chicken',
      area: 'Japanese',
      thumbnail: 'https://example.com/image.jpg',
      ingredients: ['soy sauce', 'water'],
      measures: ['3/4 cup', '1/2 cup'],
    );

    testWidgets('should display recipe name', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: testRecipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Teriyaki Chicken Casserole'), findsOneWidget);
    });

    testWidgets('should display recipe category', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: testRecipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Chicken'), findsOneWidget);
    });

    testWidgets('should display recipe area', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: testRecipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Japanese'), findsOneWidget);
    });

    testWidgets('should call onTap when card is tapped',
        (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: testRecipe,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(RecipeGridCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('should handle recipe with null thumbnail',
        (WidgetTester tester) async {
      // Arrange
      const recipeWithoutThumbnail = RecipeModel(
        id: '52772',
        name: 'Test Recipe',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: recipeWithoutThumbnail,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Recipe'), findsOneWidget);
      expect(find.byType(RecipeGridCard), findsOneWidget);
    });

    testWidgets('should handle recipe with null category and area',
        (WidgetTester tester) async {
      // Arrange
      const recipeMinimal = RecipeModel(
        id: '52772',
        name: 'Minimal Recipe',
        ingredients: [],
        measures: [],
      );

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: recipeMinimal,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Minimal Recipe'), findsOneWidget);
      expect(find.byType(RecipeGridCard), findsOneWidget);
    });

    testWidgets('should display Hero widget with correct tag',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeGridCard(
                recipe: testRecipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Hero), findsOneWidget);
    });
  });

  group('RecipeListCard Widget Tests', () {
    const testRecipe = RecipeModel(
      id: '52772',
      name: 'Teriyaki Chicken Casserole',
      category: 'Chicken',
      area: 'Japanese',
      thumbnail: 'https://example.com/image.jpg',
      ingredients: ['soy sauce'],
      measures: ['3/4 cup'],
    );

    testWidgets('should display recipe name in list view',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeListCard(
                recipe: testRecipe,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Teriyaki Chicken Casserole'), findsOneWidget);
    });

    testWidgets('should call onTap when list card is tapped',
        (WidgetTester tester) async {
      // Arrange
      bool tapped = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: RecipeListCard(
                recipe: testRecipe,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(RecipeListCard));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}

