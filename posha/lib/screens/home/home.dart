import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/constants/app_strings.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/data/repository/recipe_repository.dart';
import 'package:posha/screens/home/bloc/home_bloc.dart';
import 'package:posha/screens/home/bloc/home_event.dart';
import 'package:posha/screens/home/bloc/home_state.dart';
import 'package:posha/screens/recipe_list/recipe_list.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_bloc.dart';
import 'package:posha/screens/recipe_favourite/bloc/favourites_event.dart';
import 'package:posha/screens/recipe_favourite/recipe_favourite.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(
          create: (context) =>
              FavoritesBloc(repository: RecipeRepository())
                ..add(const FavoritesInitialized()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  final List<Widget> _screens = const [
    RecipeListScreen(),
    RecipeFavouriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<HomeBloc, HomeState>(
        listenWhen: (previous, current) {
          // Listen when tab changes to favorites tab (index 1)
          if (current is HomeTabState && current.currentIndex == 1) {
            if (previous is HomeTabState && previous.currentIndex != 1) {
              return true; // Switching to favorites tab
            }
          }
          return false;
        },
        listener: (context, state) {
          // When switching to favorites tab, refresh the favorites list
          if (state is HomeTabState && state.currentIndex == 1) {
            context.read<FavoritesBloc>().add(const FavoriteRecipesRefreshed());
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final currentIndex = state is HomeTabState ? state.currentIndex : 0;
            return IndexedStack(index: currentIndex, children: _screens);
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final currentIndex = state is HomeTabState ? state.currentIndex : 0;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: SafeArea(
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  context.read<HomeBloc>().add(HomeTabChanged(index));
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: AppColors.primary,
                unselectedItemColor: AppColors.textSecondary,
                selectedFontSize: 11.sp,
                unselectedFontSize: 11.sp,
                selectedLabelStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                ),
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                iconSize: 20.h,

                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.restaurant_menu, size: 20.h),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.restaurant_menu, size: 20.h),
                    ),
                    label: AppStrings.recipes,
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.favorite_border, size: 20.h),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.favorite, size: 20.h),
                    ),
                    label: AppStrings.favourites,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
