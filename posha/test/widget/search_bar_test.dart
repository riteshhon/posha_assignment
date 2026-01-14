import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posha/core/constants/app_strings.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_bloc.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';
import 'package:posha/screens/recipe_list/widget/search_bar.dart';

import 'search_bar_test.mocks.dart';

@GenerateMocks([RecipeListBloc])

void main() {
  group('SearchBarWidget Tests', () {
    late MockRecipeListBloc mockBloc;
    late TextEditingController controller;
    late RecipeListLoaded testState;

    setUp(() {
      mockBloc = MockRecipeListBloc();
      controller = TextEditingController();
      testState = RecipeListLoaded(
        recipes: const [
          RecipeModel(
            id: '52772',
            name: 'Teriyaki Chicken Casserole',
            ingredients: [],
            measures: [],
          ),
        ],
        filteredRecipes: const [
          RecipeModel(
            id: '52772',
            name: 'Teriyaki Chicken Casserole',
            ingredients: [],
            measures: [],
          ),
        ],
        categories: ['Chicken', 'Beef'],
        areas: ['Japanese', 'Indian'],
      );
      // Stub the stream property for BlocBuilder
      when(mockBloc.stream).thenAnswer((_) => Stream.value(testState));
    });

    tearDown(() {
      controller.dispose();
      mockBloc.close();
    });

    testWidgets('should display search hint text', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(AppStrings.searchHint), findsOneWidget);
    });

    testWidgets('should display search icon', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display filter icon button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.tune), findsOneWidget);
    });

    testWidgets('should display sort icon button', (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('should display clear button when search query exists',
        (WidgetTester tester) async {
      // Arrange
      final stateWithSearch = testState.copyWith(searchQuery: 'chicken');
      when(mockBloc.state).thenAnswer((_) => stateWithSearch);
      controller.text = 'chicken';

      // Act
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: stateWithSearch,
                ),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should dispatch search event when text changes',
        (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Assert
      verify(mockBloc.add(const RecipeListSearchChanged('chicken'))).called(1);
    });

    testWidgets('should dispatch clear search event when clear button is tapped',
        (WidgetTester tester) async {
      // Arrange
      final stateWithSearch = testState.copyWith(searchQuery: 'chicken');
      when(mockBloc.state).thenAnswer((_) => stateWithSearch);
      controller.text = 'chicken';

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: stateWithSearch,
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const RecipeListSearchChanged(''))).called(1);
    });

    testWidgets('should dispatch filter panel opened event when filter button is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pump();

      // Assert
      verify(mockBloc.add(const RecipeListFilterPanelOpened())).called(1);
    });

    testWidgets('should display sort menu when sort button is tapped',
        (WidgetTester tester) async {
      // Arrange
      when(mockBloc.state).thenAnswer((_) => testState);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: BlocProvider<RecipeListBloc>.value(
                value: mockBloc,
                child: SearchBarWidget(
                  controller: controller,
                  state: testState,
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.sortNone), findsOneWidget);
      expect(find.text(AppStrings.sortAZ), findsOneWidget);
      expect(find.text(AppStrings.sortZA), findsOneWidget);
    });
  });
}

