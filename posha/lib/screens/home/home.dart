import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:posha/core/theme/app_colors.dart';
import 'package:posha/screens/home/bloc/home_bloc.dart';
import 'package:posha/screens/home/bloc/home_event.dart';
import 'package:posha/screens/home/bloc/home_state.dart';
import 'package:posha/screens/recipe_list/recipe_list.dart';
import 'package:posha/screens/recipe_favourite/recipe_favourite.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final currentIndex = state is HomeTabState ? state.currentIndex : 0;
          return IndexedStack(index: currentIndex, children: _screens);
        },
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
                selectedFontSize: 12.sp,
                unselectedFontSize: 12.sp,
                selectedLabelStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 0.2,
                ),
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                iconSize: 24.sp,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.restaurant_menu, size: 24.sp),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.restaurant_menu, size: 26.sp),
                    ),
                    label: 'Recipes',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.favorite_border, size: 24.sp),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Icon(Icons.favorite, size: 26.sp),
                    ),
                    label: 'Favourites',
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
