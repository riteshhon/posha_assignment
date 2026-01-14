import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/constants/app_strings.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:posha/screens/recipe_details/widget/youtube_player_widget.dart';

/// Recipe Details Tab Content
class RecipeDetailsTabs extends StatelessWidget {
  final RecipeModel recipe;
  final TabController tabController;

  const RecipeDetailsTabs({
    super.key,
    required this.recipe,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _OverviewTab(recipe: recipe),
        _IngredientsTab(recipe: recipe),
        _InstructionsTab(recipe: recipe),
      ],
    );
  }
}

/// Overview Tab
class _OverviewTab extends StatelessWidget {
  final RecipeModel recipe;

  const _OverviewTab({required this.recipe});

  Widget _buildInfoCards(RecipeModel recipe) {
    final cards = <Widget>[];

    if (recipe.category != null) {
      cards.add(
        _InfoCard(
          icon: Icons.category,
          label: AppStrings.category,
          value: recipe.category!,
        ),
      );
    }

    if (recipe.area != null) {
      cards.add(
        _InfoCard(icon: Icons.public, label: AppStrings.cuisine, value: recipe.area!),
      );
    }

    if (recipe.ingredients.isNotEmpty) {
      cards.add(
        _InfoCard(
          icon: Icons.restaurant,
          label: AppStrings.ingredients,
          value: '${recipe.ingredients.length} ${AppStrings.items}',
        ),
      );
    }

    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    if (cards.length == 1) {
      return cards[0];
    }

    return Row(
      children: cards
          .map((card) => Expanded(child: card))
          .expand((widget) => [widget, SizedBox(width: 12.w)])
          .take(cards.length * 2 - 1)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Cards Section
          if (recipe.category != null || recipe.area != null) ...[
            Text(
              AppStrings.recipeInfo,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            _buildInfoCards(recipe),
            SizedBox(height: 15.h),
          ],
          // YouTube Video
          if (recipe.youtubeUrl != null && recipe.youtubeUrl!.isNotEmpty) ...[
            Text(
              AppStrings.videoTutorial,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 5.h),
            YouTubePlayerWidget(videoUrl: recipe.youtubeUrl!),
          ],
        ],
      ),
    );
  }
}

/// Ingredients Tab
class _IngredientsTab extends StatelessWidget {
  final RecipeModel recipe;

  const _IngredientsTab({required this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe.ingredients.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_outlined,
                size: 64.sp,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.noIngredientsAvailable,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: 16.h),
        // Ingredients List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: recipe.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = recipe.ingredients[index];
              final measure = index < recipe.measures.length
                  ? recipe.measures[index]
                  : '';

              return _IngredientItem(
                index: index,
                ingredient: ingredient,
                measure: measure,
                isLast: index == recipe.ingredients.length - 1,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Individual Ingredient Item Widget
class _IngredientItem extends StatelessWidget {
  final int index;
  final String ingredient;
  final String measure;
  final bool isLast;

  const _IngredientItem({
    required this.index,
    required this.ingredient,
    required this.measure,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 20.h : 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Number Badge with Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 30.w,
                  color: AppColors.primary.withOpacity(0.1),
                ),
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // Ingredient Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ingredient,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                if (measure.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surfaceVariant,
                          AppColors.surfaceVariant.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.scale,
                          size: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          measure,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Instructions Tab
class _InstructionsTab extends StatelessWidget {
  final RecipeModel recipe;

  const _InstructionsTab({required this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe.instructions == null || recipe.instructions!.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.article_outlined,
                size: 64.sp,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                AppStrings.noInstructionsAvailable,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Clean and format instructions
    final cleanedInstructions = _cleanInstructions(recipe.instructions!);

    return SingleChildScrollView(
      padding: EdgeInsets.all(10.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Text(
          cleanedInstructions,
          style: TextStyle(
            fontSize: 12.sp,
            height: 1.8,
            color: AppColors.textPrimary,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String _cleanInstructions(String instructions) {
    // Remove step numbers and formatting
    String cleaned = instructions;

    // Remove numbered steps (Step 1, Step 2, etc.)
    cleaned = cleaned.replaceAll(
      RegExp(r'[Ss]tep\s+\d+[.:]\s*', caseSensitive: false),
      '',
    );

    // Remove standalone numbers at the start of lines (1., 2., etc.)
    cleaned = cleaned.replaceAll(RegExp(r'^\d+[.)]\s*', multiLine: true), '');

    // Remove multiple consecutive newlines
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // Clean up spacing around periods
    cleaned = cleaned.replaceAll(RegExp(r'\.\s+\.'), '.');

    // Trim each line and remove empty lines
    final lines = cleaned
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Join with proper spacing
    return lines.join('\n\n').trim();
  }
}

/// Info Card Widget
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 20.sp, color: AppColors.primary),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
