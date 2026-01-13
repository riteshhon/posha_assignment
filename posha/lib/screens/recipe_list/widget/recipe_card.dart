import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/data/models/recipe_model.dart';
import 'package:shimmer/shimmer.dart';

/// Recipe Card Widget - Grid View
class RecipeGridCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const RecipeGridCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with Hero animation and gradient overlay
            Stack(
              children: [
                Hero(
                  tag: 'recipe_image_${recipe.id}',
                  child: Container(
                    height: 125.h,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                    child: recipe.thumbnail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16.r),
                            ),
                            child: Image.network(
                              recipe.thumbnail!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildImagePlaceholder();
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return _buildImageShimmer();
                                  },
                            ),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),
                // Gradient overlay for better text readability
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Category badge
                if (recipe.category != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: _CategoryBadge(category: recipe.category!),
                  ),
              ],
            ),
            // Content - Constrained to prevent overflow
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        recipe.name,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.2,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (recipe.area != null) ...[
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.public,
                            size: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              recipe.area!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.textSecondary,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 40.sp,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
      ),
    );
  }
}

/// Category Badge Widget
class _CategoryBadge extends StatelessWidget {
  final String category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
          letterSpacing: 0.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Recipe Card Widget - List View
class RecipeListCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const RecipeListCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Hero animation
            Hero(
              tag: 'recipe_image_${recipe.id}',
              child: Container(
                width: 130.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16.r),
                  ),
                ),
                child: recipe.thumbnail != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(16.r),
                        ),
                        child: Image.network(
                          recipe.thumbnail!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildListImagePlaceholder();
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildListImageShimmer();
                          },
                        ),
                      )
                    : _buildListImagePlaceholder(),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.3,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: [
                            if (recipe.category != null)
                              _InfoChip(
                                icon: Icons.category,
                                label: recipe.category!,
                              ),
                            if (recipe.area != null)
                              _InfoChip(
                                icon: Icons.public,
                                label: recipe.area!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 40.sp,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildListImageShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16.r)),
        ),
      ),
    );
  }
}

/// Info Chip Widget for List View
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
