import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/recipe_favourite/bloc/favorites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favorites_event.dart';
import 'package:posha/screens/recipe_details/bloc/recipe_details_bloc.dart';
import 'package:posha/screens/recipe_details/bloc/recipe_details_event.dart';
import 'package:posha/screens/recipe_details/bloc/recipe_details_state.dart';
import 'package:posha/screens/recipe_details/widget/favorite_button.dart';
import 'package:posha/screens/recipe_details/widget/image_zoom_viewer.dart';
import 'package:posha/screens/recipe_details/widget/recipe_details_tabs.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String? recipeId;
  final RecipeModel? recipe;

  const RecipeDetailsScreen({super.key, this.recipeId, this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              RecipeDetailsBloc(repository: RecipeRepository())..add(
                RecipeDetailsInitialized(
                  recipeId: widget.recipeId,
                  recipe: widget.recipe,
                ),
              ),
        ),
        BlocProvider(
          create: (context) =>
              FavoritesBloc()..add(const FavoritesInitialized()),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
          builder: (context, state) {
            if (state is RecipeDetailsLoading) {
              return _buildLoadingView();
            }

            if (state is RecipeDetailsError) {
              return _buildErrorView(state.message);
            }

            if (state is RecipeDetailsLoaded) {
              return _buildRecipeDetails(state.recipe);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details', style: TextStyle(fontSize: 16.sp)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: 16.h),
            Text(
              'Loading recipe...',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details', style: TextStyle(fontSize: 16.sp)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
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
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  context.read<RecipeDetailsBloc>().add(
                    RecipeDetailsInitialized(
                      recipeId: widget.recipeId,
                      recipe: widget.recipe,
                    ),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeDetails(RecipeModel recipe) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildAppBar(recipe),
          _buildImageHeader(recipe),
          _buildTitleHeader(recipe),
          _buildTabBar(),
        ];
      },
      body: RecipeDetailsTabs(recipe: recipe, tabController: _tabController),
    );
  }

  Widget _buildAppBar(RecipeModel recipe) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      title: Text('Recipe Details', style: TextStyle(fontSize: 16.sp)),
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        FavoriteButton(recipeId: recipe.id),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildImageHeader(RecipeModel recipe) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          if (recipe.thumbnail != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageZoomViewer(
                  imageUrl: recipe.thumbnail!,
                  heroTag: 'recipe_image_${recipe.id}',
                ),
              ),
            );
          }
        },
        child: Hero(
          tag: 'recipe_image_${recipe.id}',
          child: Stack(
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.surfaceVariant),
                child: recipe.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: recipe.thumbnail!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.surfaceVariant,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surfaceVariant,
                          child: Center(
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 64.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surfaceVariant,
                        child: Center(
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 64.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
              ),
              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              // Tap indicator
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.zoom_in, color: Colors.white, size: 20.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleHeader(RecipeModel recipe) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.surface,
        padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.name,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 12.h),
            // Quick info row
            if (recipe.category != null || recipe.area != null)
              Wrap(
                spacing: 12.w,
                runSpacing: 8.h,
                children: [
                  if (recipe.category != null)
                    _quickInfoChip(
                      icon: Icons.category,
                      label: recipe.category!,
                    ),
                  if (recipe.area != null)
                    _quickInfoChip(icon: Icons.public, label: recipe.area!),
                  if (recipe.ingredients.isNotEmpty)
                    _quickInfoChip(
                      icon: Icons.restaurant,
                      label: '${recipe.ingredients.length} Ingredients',
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _quickInfoChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.h, color: AppColors.primary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Ingredients'),
            Tab(text: 'Instructions'),
          ],
        ),
      ),
    );
  }
}

/// Custom SliverPersistentHeaderDelegate for TabBar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}
