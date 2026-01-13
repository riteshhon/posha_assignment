import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_bloc.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_event.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';

/// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final RecipeListLoaded state;

  const SearchBarWidget({required this.controller, required this.state});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      buildWhen: (previous, current) {
        if (previous is RecipeListLoaded && current is RecipeListLoaded) {
          return previous.searchQuery != current.searchQuery ||
              previous.sortType != current.sortType ||
              previous.selectedCategory != current.selectedCategory ||
              previous.selectedArea != current.selectedArea;
        }
        return false;
      },
      builder: (context, blocState) {
        if (blocState is! RecipeListLoaded) {
          return const SizedBox.shrink();
        }

        final hasSearchQuery =
            blocState.searchQuery != null && blocState.searchQuery!.isNotEmpty;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  prefixIcon: Icon(Icons.search, size: 20.sp),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FilterIconButton(state: blocState),
                      if (hasSearchQuery)
                        _ClearSearchButton(controller: controller),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                ),
                onChanged: (value) {
                  context.read<RecipeListBloc>().add(
                    RecipeListSearchChanged(value),
                  );
                },
              ),
            ),
            SizedBox(width: 6.w),
            _SortButton(state: blocState),
          ],
        );
      },
    );
  }
}

/// Filter Icon Button
class _FilterIconButton extends StatelessWidget {
  final RecipeListLoaded state;

  const _FilterIconButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters =
        state.selectedCategory != null || state.selectedArea != null;

    return IconButton(
      icon: Stack(
        children: [
          Icon(
            Icons.tune,
            size: 20.sp,
            color: hasActiveFilters
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
          if (hasActiveFilters)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
      tooltip: 'Filters',
      onPressed: () {
        context.read<RecipeListBloc>().add(const RecipeListFilterPanelOpened());
      },
    );
  }
}

/// Clear Search Button
class _ClearSearchButton extends StatelessWidget {
  final TextEditingController controller;

  const _ClearSearchButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.clear, size: 20.sp),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 28.w, minHeight: 28.h),
      onPressed: () {
        controller.clear();
        context.read<RecipeListBloc>().add(const RecipeListSearchChanged(''));
      },
    );
  }
}

/// Sort Button
class _SortButton extends StatelessWidget {
  final RecipeListLoaded state;

  const _SortButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      child: PopupMenuButton<RecipeListSortType>(
        icon: Icon(
          Icons.sort,
          size: 20.sp,
          color: state.sortType != RecipeListSortType.none
              ? AppColors.primary
              : AppColors.textSecondary,
        ),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(minWidth: 32.w, minHeight: 32.h),
        tooltip: 'Sort',
        itemBuilder: (context) => [
          PopupMenuItem(
            value: RecipeListSortType.none,
            child: Row(
              children: [
                if (state.sortType == RecipeListSortType.none)
                  Icon(Icons.check, size: 16.sp, color: AppColors.primary)
                else
                  SizedBox(width: 16.w),
                SizedBox(width: 8.w),
                const Text('None'),
              ],
            ),
          ),
          PopupMenuItem(
            value: RecipeListSortType.nameAsc,
            child: Row(
              children: [
                if (state.sortType == RecipeListSortType.nameAsc)
                  Icon(Icons.check, size: 16.sp, color: AppColors.primary)
                else
                  SizedBox(width: 16.w),
                SizedBox(width: 8.w),
                const Text('Name (A-Z)'),
              ],
            ),
          ),
          PopupMenuItem(
            value: RecipeListSortType.nameDesc,
            child: Row(
              children: [
                if (state.sortType == RecipeListSortType.nameDesc)
                  Icon(Icons.check, size: 16.sp, color: AppColors.primary)
                else
                  SizedBox(width: 16.w),
                SizedBox(width: 8.w),
                const Text('Name (Z-A)'),
              ],
            ),
          ),
        ],
        onSelected: (value) {
          context.read<RecipeListBloc>().add(RecipeListSortChanged(value));
        },
      ),
    );
  }
}
