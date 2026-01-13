import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_bloc.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';

/// Filter Panel Wrapper
class FilterPanelWrapperWidget extends StatelessWidget {
  final Widget child;

  const FilterPanelWrapperWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      buildWhen: (previous, current) {
        if (previous is RecipeListLoaded && current is RecipeListLoaded) {
          return previous.showFilterPanel != current.showFilterPanel;
        }
        return false;
      },
      builder: (context, state) {
        final showFilterPanel = state is RecipeListLoaded
            ? state.showFilterPanel
            : false;

        return Stack(
          children: [
            child,
            if (showFilterPanel) _FilterPanelBackdrop(),
            _FilterPanel(isVisible: showFilterPanel),
          ],
        );
      },
    );
  }
}

/// Filter Panel Backdrop
class _FilterPanelBackdrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          context.read<RecipeListBloc>().add(
            const RecipeListFilterPanelClosed(),
          );
        },
        child: Container(color: Colors.black.withOpacity(0.3)),
      ),
    );
  }
}

/// Filter Panel
class _FilterPanel extends StatelessWidget {
  final bool isVisible;

  const _FilterPanel({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth * 0.72;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      right: isVisible ? 0 : -panelWidth,
      top: 0,
      bottom: 0,
      width: panelWidth,
      child: GestureDetector(
        onTap: () {}, // Prevent tap from closing
        child: Material(
          color: AppColors.surface,
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: BlocBuilder<RecipeListBloc, RecipeListState>(
              builder: (context, state) {
                if (state is! RecipeListLoaded) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    _FilterPanelHeader(
                      onClose: () {
                        context.read<RecipeListBloc>().add(
                          const RecipeListFilterPanelClosed(),
                        );
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FilterSection(
                              title: 'Categories',
                              icon: Icons.category,
                              items: state.categories,
                              selectedItem: state.selectedCategory,
                              onItemSelected: (category) {
                                context.read<RecipeListBloc>().add(
                                  RecipeListCategoryFilterChanged(category),
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            _FilterSection(
                              title: 'Cuisine Areas',
                              icon: Icons.public,
                              items: state.areas,
                              selectedItem: state.selectedArea,
                              onItemSelected: (area) {
                                context.read<RecipeListBloc>().add(
                                  RecipeListAreaFilterChanged(area),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.activeFilterCount > 0) _FilterPanelFooter(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter Panel Header
class _FilterPanelHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _FilterPanelHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 2,
            offset: Offset(0, 1.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.tune, color: AppColors.textOnPrimary, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Filters',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: AppColors.textOnPrimary,
              size: 20.sp,
            ),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

/// Filter Section
class _FilterSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onItemSelected;

  const _FilterSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: AppColors.textSecondary),
            SizedBox(width: 6.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            _FilterChip(
              label: 'All',
              isSelected: selectedItem == null,
              onTap: () => onItemSelected(null),
            ),
            ...items.map(
              (item) => _FilterChip(
                label: item,
                isSelected: selectedItem == item,
                onTap: () => onItemSelected(item),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Filter Panel Footer
class _FilterPanelFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          icon: Icon(Icons.clear_all, size: 16.sp),
          label: Text('Clear All', style: TextStyle(fontSize: 12.sp)),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
          ),
          onPressed: () {
            context.read<RecipeListBloc>().add(
              const RecipeListFiltersCleared(),
            );
          },
        ),
      ),
    );
  }
}

/// Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border.withOpacity(0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 14.sp,
                color: AppColors.textOnPrimary,
              ),
            if (isSelected) SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
