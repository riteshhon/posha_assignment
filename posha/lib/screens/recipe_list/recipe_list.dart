import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/routes/navigation_helper.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_bloc.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';
import 'package:posha/screens/recipe_list/widget/filter_panel.dart';
import 'package:posha/screens/recipe_list/widget/recipe_card.dart';
import 'package:posha/screens/recipe_list/widget/recipe_skeleton.dart';
import 'package:posha/screens/recipe_list/widget/search_filter.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecipeListBloc(repository: RecipeRepository())
            ..add(const RecipeListInitialized()),
      child: const _RecipeListView(),
    );
  }
}

class _RecipeListView extends StatelessWidget {
  const _RecipeListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes', style: TextStyle(fontSize: 16.sp)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(height: 1.h, color: AppColors.border),
        ),
        actions: const [_ViewModeToggleButton()],
      ),
      body: FilterPanelWrapperWidget(
        child: Column(
          children: [
            const SearchAndFiltersSectionWidget(),
            Expanded(child: _RecipeListContent()),
          ],
        ),
      ),
    );
  }
}

/// Recipe List Content Widget
class _RecipeListContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        if (state is RecipeListLoading) {
          return _buildLoadingView(context);
        } else if (state is RecipeListError) {
          return _buildErrorView(context, state.message);
        } else if (state is RecipeListLoaded) {
          if (state.isSearching) {
            return _buildShimmerLoadingView(context, state.isGridView);
          }
          if (state.filteredRecipes.isEmpty) {
            return _buildEmptyView(context);
          }
          return _buildRecipeList(context, state);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        final isGridView = state is RecipeListLoaded ? state.isGridView : true;
        return _buildShimmerLoadingView(context, isGridView);
      },
    );
  }

  Widget _buildShimmerLoadingView(BuildContext context, bool isGridView) {
    if (isGridView) {
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
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: 6,
        itemBuilder: (context, index) => const RecipeListSkeleton(),
      );
    }
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
                context.read<RecipeListBloc>().add(const RecipeListRefreshed());
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
            Icon(Icons.search_off, size: 64.sp, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No recipes found',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search or filters',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, RecipeListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecipeListBloc>().add(const RecipeListRefreshed());
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: state.isGridView
            ? GridView.builder(
                key: ValueKey('grid_${state.filteredRecipes.length}'),
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.72,
                ),
                itemCount: state.filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.filteredRecipes[index];
                  return RecipeGridCard(
                    key: ValueKey('recipe_${recipe.id}'),
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
              )
            : ListView.builder(
                key: ValueKey('list_${state.filteredRecipes.length}'),
                padding: EdgeInsets.all(16.w),
                itemCount: state.filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.filteredRecipes[index];
                  return RecipeListCard(
                    key: ValueKey('recipe_${recipe.id}'),
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
      ),
    );
  }
}

/// View Mode Toggle Button
class _ViewModeToggleButton extends StatelessWidget {
  const _ViewModeToggleButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        if (state is RecipeListLoaded) {
          return IconButton(
            icon: Icon(state.isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              context.read<RecipeListBloc>().add(
                const RecipeListViewModeToggled(),
              );
            },
            tooltip: state.isGridView ? 'List View' : 'Grid View',
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
