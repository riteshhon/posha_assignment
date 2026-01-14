import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/routes/navigation_helper.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_state.dart';
import 'package:posha/screens/recipe_list/widget/recipe_card.dart';
import 'package:posha/screens/recipe_list/widget/recipe_skeleton.dart';

class RecipeFavouriteScreen extends StatefulWidget {
  const RecipeFavouriteScreen({super.key});

  @override
  State<RecipeFavouriteScreen> createState() => _RecipeFavouriteScreenState();
}

class _RecipeFavouriteScreenState extends State<RecipeFavouriteScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize recipes list when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesBloc>().add(const FavoriteRecipesInitialized());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Recipes', style: TextStyle(fontSize: 16.sp)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(height: 1.h, color: AppColors.border),
        ),
      ),
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listenWhen: (previous, current) {
          // Listen to all state changes to ensure we catch favorites updates
          // This works even when the screen is not visible (in IndexedStack)
          return true;
        },
        listener: (context, state) {
          // When favorites change (IDs change), refresh recipes list
          if (state is FavoritesLoaded) {
            // Only refresh if we have favorites and repository is available
            final bloc = context.read<FavoritesBloc>();
            if (state.favoriteIds.isNotEmpty) {
              // Check if we need to refresh (if current state is not FavoriteRecipesLoaded)
              if (bloc.state is! FavoriteRecipesLoaded) {
                bloc.add(const FavoriteRecipesRefreshed());
              }
            }
          }
        },
        child: const _FavoriteRecipesContent(),
      ),
    );
  }
}

class _FavoriteRecipesContent extends StatelessWidget {
  const _FavoriteRecipesContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      buildWhen: (previous, current) {
        // Always rebuild when recipes list states change
        // This ensures UI updates immediately when favorites change
        if (current is FavoriteRecipesLoading ||
            current is FavoriteRecipesLoaded ||
            current is FavoriteRecipesEmpty ||
            current is FavoritesError) {
          return true;
        }
        // Also rebuild when transitioning from FavoriteRecipesLoaded to FavoritesLoaded
        // This handles the case when favorites are toggled from other screens
        if (current is FavoritesLoaded && previous is FavoriteRecipesLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is FavoriteRecipesLoading) {
          return _buildLoadingView(context);
        } else if (state is FavoritesError) {
          return _buildErrorView(context, state.message);
        } else if (state is FavoriteRecipesEmpty) {
          return _buildEmptyView(context);
        } else if (state is FavoriteRecipesLoaded) {
          return _buildRecipesList(context, state.recipes);
        }
        // If showing FavoritesLoaded (IDs only), show appropriate view
        if (state is FavoritesLoaded) {
          if (state.favoriteIds.isEmpty) {
            return _buildEmptyView(context);
          }
          // Show loading while recipes are being fetched
          return _buildLoadingView(context);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const RecipeGridSkeleton(),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<FavoritesBloc>().add(
                  const FavoriteRecipesRefreshed(),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60.sp,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Start adding recipes to your favorites\nby tapping the heart icon',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesList(BuildContext context, List recipes) {
    if (recipes.isEmpty) {
      return _buildEmptyView(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FavoritesBloc>().add(const FavoriteRecipesRefreshed());
        // Wait a bit for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.72,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeGridCard(
            recipe: recipe,
            onTap: () {
              NavigationHelper.toRecipeDetails(
                context,
                recipeId: recipe.id,
                recipe: recipe,
              );
            },
          );
        },
      ),
    );
  }
}
