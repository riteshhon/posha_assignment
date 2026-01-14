import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_state.dart';

import 'favorites_bloc_test.mocks.dart';

@GenerateMocks([RecipeRepository])
void main() {
  late FavoritesBloc bloc;
  late MockRecipeRepository mockRepository;

  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('test/hive_test');
  });

  tearDownAll(() async {
    // Clean up Hive boxes after all tests
    try {
      if (Hive.isBoxOpen('favorites')) {
        await Hive.box('favorites').close();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  });

  final mockRecipe = const RecipeModel(
    id: '52772',
    name: 'Teriyaki Chicken Casserole',
    category: 'Chicken',
    area: 'Japanese',
    ingredients: ['soy sauce'],
    measures: ['3/4 cup'],
  );

  /// Helper function to safely ensure Hive box is open
  Future<void> _ensureHiveBoxOpen() async {
    try {
      if (!Hive.isBoxOpen('favorites')) {
        await Hive.openBox('favorites');
      }
    } catch (e) {
      // Box might already be open or locked, try to get existing box
      if (Hive.isBoxOpen('favorites')) {
        // Box is already open, that's fine
        return;
      }
      // If we can't open it, wait a bit and try again (for lock issues)
      await Future.delayed(const Duration(milliseconds: 50));
      if (!Hive.isBoxOpen('favorites')) {
        await Hive.openBox('favorites');
      }
    }
  }

  setUp(() async {
    // Ensure box is closed before each test to avoid lock issues
    try {
      if (Hive.isBoxOpen('favorites')) {
        await Hive.box('favorites').close();
      }
    } catch (e) {
      // Ignore if box is not open
    }
    mockRepository = MockRecipeRepository();
    bloc = FavoritesBloc(repository: mockRepository);
  });

  tearDown(() async {
    bloc.close();
    // Clean up box after each test
    try {
      if (Hive.isBoxOpen('favorites')) {
        final box = Hive.box('favorites');
        await box.clear();
        await box.close();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  });

  group('FavoritesBloc - Initialization', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'emits FavoritesLoaded when initialized with favorite IDs',
      build: () {
        // Initialize Hive box before testing
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      act: (bloc) => bloc.add(const FavoritesInitialized()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<FavoritesLoaded>().having(
          (s) => s.favoriteIds,
          'favoriteIds',
          isA<Set<String>>(),
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'emits FavoriteRecipesLoaded when recipes initialized',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      act: (bloc) => bloc.add(const FavoriteRecipesInitialized()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        const FavoriteRecipesLoading(),
        anyOf(isA<FavoriteRecipesEmpty>(), isA<FavoriteRecipesLoaded>()),
      ],
    );
  });

  group('FavoritesBloc - Toggle Favorite', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'toggles favorite status and updates state',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      seed: () => const FavoritesLoaded({}),
      act: (bloc) => bloc.add(const FavoriteToggled('52772')),
      wait: const Duration(milliseconds: 300),
      // When toggling from FavoritesLoaded, it loads recipes which emits FavoriteRecipesLoading first
      expect: () => [
        const FavoriteRecipesLoading(),
        isA<FavoriteRecipesLoaded>().having(
          (s) => s.isFavorite('52772'),
          'isFavorite',
          true,
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'removes recipe from favorites list when toggled off',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      seed: () =>
          FavoriteRecipesLoaded(recipes: [mockRecipe], favoriteIds: {'52772'}),
      act: (bloc) => bloc.add(const FavoriteToggled('52772')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        anyOf(
          isA<FavoriteRecipesEmpty>(),
          isA<FavoriteRecipesLoaded>().having(
            (s) => s.recipes.length,
            'recipes length',
            0,
          ),
        ),
      ],
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'adds recipe to favorites list when toggled on',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      seed: () => FavoriteRecipesLoaded(recipes: [], favoriteIds: {}),
      act: (bloc) => bloc.add(const FavoriteToggled('52772')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<FavoriteRecipesLoaded>().having(
          (s) => s.recipes.length,
          'recipes length',
          1,
        ),
      ],
    );
  });

  group('FavoritesBloc - Add Favorite', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'adds recipe to favorites',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      seed: () => FavoriteRecipesLoaded(recipes: [], favoriteIds: {}),
      act: (bloc) => bloc.add(const FavoriteAdded('52772')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        isA<FavoriteRecipesLoaded>()
            .having((s) => s.recipes.length, 'recipes length', 1)
            .having((s) => s.isFavorite('52772'), 'isFavorite', true),
      ],
    );
  });

  group('FavoritesBloc - Remove Favorite', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'removes recipe from favorites',
      build: () => bloc,
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      seed: () =>
          FavoriteRecipesLoaded(recipes: [mockRecipe], favoriteIds: {'52772'}),
      act: (bloc) => bloc.add(const FavoriteRemoved('52772')),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        anyOf(
          isA<FavoriteRecipesEmpty>(),
          isA<FavoriteRecipesLoaded>().having(
            (s) => s.recipes.length,
            'recipes length',
            0,
          ),
        ),
      ],
    );
  });

  group('FavoritesBloc - Refresh', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'refreshes favorite recipes list',
      build: () {
        when(
          mockRepository.getRecipeById('52772'),
        ).thenAnswer((_) async => mockRecipe);
        return bloc;
      },
      setUp: () async {
        // Ensure Hive box is open
        await _ensureHiveBoxOpen();
      },
      act: (bloc) => bloc.add(const FavoriteRecipesRefreshed()),
      wait: const Duration(milliseconds: 300),
      expect: () => [
        const FavoriteRecipesLoading(),
        anyOf(isA<FavoriteRecipesEmpty>(), isA<FavoriteRecipesLoaded>()),
      ],
    );
  });

  group('FavoritesBloc - Error Handling', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'emits error state when repository is not provided',
      build: () => FavoritesBloc(),
      act: (bloc) => bloc.add(const FavoriteRecipesInitialized()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<FavoritesError>().having(
          (s) => s.message,
          'message',
          'Repository not provided',
        ),
      ],
    );
  });
}
