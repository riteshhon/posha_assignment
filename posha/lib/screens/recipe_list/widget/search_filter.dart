import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_bloc.dart';
import 'package:posha/screens/recipe_list/bloc/recipe_list_state.dart';
import 'package:posha/screens/recipe_list/widget/search_bar.dart';

/// Search and Filters Section
class SearchAndFiltersSectionWidget extends StatefulWidget {
  const SearchAndFiltersSectionWidget();

  @override
  State<SearchAndFiltersSectionWidget> createState() =>
      _SearchAndFiltersSectionWidgetState();
}

class _SearchAndFiltersSectionWidgetState
    extends State<SearchAndFiltersSectionWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeListBloc, RecipeListState>(
      listenWhen: (previous, current) {
        if (previous is RecipeListLoaded && current is RecipeListLoaded) {
          return previous.searchQuery != current.searchQuery;
        }
        return false;
      },
      listener: (context, state) {
        if (state is RecipeListLoaded) {
          if (state.searchQuery == null || state.searchQuery!.isEmpty) {
            if (_searchController.text.isNotEmpty) {
              _searchController.clear();
            }
          } else if (_searchController.text != state.searchQuery) {
            final selection = _searchController.selection;
            _searchController.value = TextEditingValue(
              text: state.searchQuery!,
              selection: selection,
            );
          }
        }
      },
      child: BlocBuilder<RecipeListBloc, RecipeListState>(
        builder: (context, state) {
          if (state is! RecipeListLoaded) {
            return const SizedBox.shrink();
          }

          return Container(
            color: AppColors.surface,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              child: SearchBarWidget(
                controller: _searchController,
                state: state,
              ),
            ),
          );
        },
      ),
    );
  }
}
