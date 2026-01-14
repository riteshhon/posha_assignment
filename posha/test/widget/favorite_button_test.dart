import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_state.dart';
import 'package:posha/screens/recipe_details/widget/favourite_button.dart';

import 'favorite_button_test.mocks.dart';

@GenerateMocks([FavoritesBloc])
void main() {
  group('FavoriteButton Widget Tests', () {
    late MockFavoritesBloc mockBloc;

    setUp(() {
      mockBloc = MockFavoritesBloc();
      // Stub the stream property for BlocBuilder
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({})));
    });

    tearDown(() {
      mockBloc.close();
    });

    testWidgets('should display favorite border icon when not favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({})));

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should display favorite icon when favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({'52772'}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({'52772'})));

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should dispatch FavoriteToggled event when button is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({})));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const FavoriteToggled('52772'))).called(1);
    });

    testWidgets('should display correct tooltip when not favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({})));

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Assert
      final tooltip = find.byType(Tooltip);
      expect(tooltip, findsOneWidget);
    });

    testWidgets('should display correct tooltip when favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({'52772'}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({'52772'})));

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Assert
      final tooltip = find.byType(Tooltip);
      expect(tooltip, findsOneWidget);
    });

    testWidgets('should handle FavoriteRecipesLoaded state correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const state = FavoriteRecipesLoaded(recipes: [], favoriteIds: {'52772'});
      when(mockBloc.state).thenAnswer((_) => state);
      when(mockBloc.stream).thenAnswer((_) => Stream.value(state));

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should display favorite icon when recipe is favorited', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => const FavoritesLoaded({'52772'}));
      when(
        mockBloc.stream,
      ).thenAnswer((_) => Stream.value(const FavoritesLoaded({'52772'})));

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<FavoritesBloc>.value(
                value: mockBloc,
                child: const FavoriteButton(recipeId: '52772'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });
}
