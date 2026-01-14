import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_state.dart';

/// Animated Favorite Toggle Button
class FavoriteButton extends StatelessWidget {
  final String recipeId;

  const FavoriteButton({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite =
            (state is FavoritesLoaded && state.isFavorite(recipeId)) ||
            (state is FavoriteRecipesLoaded && state.isFavorite(recipeId));

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: IconButton(
            key: ValueKey(isFavorite),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.primary : AppColors.textSecondary,
              size: 24.sp,
            ),
            onPressed: () {
              context.read<FavoritesBloc>().add(FavoriteToggled(recipeId));
            },
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        );
      },
    );
  }
}
