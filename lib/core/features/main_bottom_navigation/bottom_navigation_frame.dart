import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_template_app/core/features/main_bottom_navigation/cubits/main_bottom_navigation/main_bottom_navigation_cubit.dart';
import 'package:flutter_template_app/theme/app_box_shadows.dart';
import 'package:flutter_template_app/theme/get_theme_color.dart';
import 'package:flutter_template_app/theme/theme_color.dart';
import 'package:go_router/go_router.dart';

class BottomNavigationFrame extends StatelessWidget {
  const BottomNavigationFrame(this.navigationShell, {super.key});

  /// The navigation shell is container where shell-branches will display,
  ///
  /// for example content of the Home, Meters, Service... tabs
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.primaryBackground,
      // backgroundColor: getSelectedThemeColors(context).primaryBackground,
      body: navigationShell,
      bottomNavigationBar: BlocListener<MainBottomNavigationCubit, MainBottomNavigationState>(
        listener: (context, state) {
          int index = state.currentScreen.value;

          // Listen to the current screen and update the bottom navigation bar
          navigationShell.goBranch(
            index,
            // A common pattern when using bottom navigation bars is to support
            // navigating to the initial location when tapping the item that is
            // already active. This example demonstrates how to support this behavior,
            // using the initialLocation parameter of goBranch.
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        child: Builder(builder: (context) {
          return BottomNavigationBar(
            unselectedLabelStyle: const TextStyle(
              // color: AppColors.primaryText,
              fontSize: 12,
            ),
            selectedLabelStyle: const TextStyle(
              // color: AppColors.primaryTitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            selectedItemColor: AppColors.primaryText,
            unselectedItemColor: AppColors.secondaryText,
            type: BottomNavigationBarType.fixed, // This allow more than 3 items
            currentIndex: navigationShell.currentIndex,
            // backgroundColor: getSelectedThemeColors(context).baseWhite,
            backgroundColor: context.colors.primaryBackground,
            items: const [
              BottomNavigationBarItem(
                icon: BottomNavIcon(svgIconPath: 'assets/svg/bottom_navigation/home.svg'),
                activeIcon: BottomNavIcon(
                  svgIconPath: 'assets/svg/bottom_navigation/home_selected.svg',
                  selectedIconColor: AppColors.textBlue,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: BottomNavIcon(svgIconPath: 'assets/svg/bottom_navigation/history.svg'),
                activeIcon: BottomNavIcon(
                  svgIconPath: 'assets/svg/bottom_navigation/history_selected.svg',
                  selectedIconColor: AppColors.textBlue,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              _onTap(index, context);
            },
          );
        }),
      ),
    );
  }

  void _onTap(int index, BuildContext context) {
    // print('--- bottom navigation changed $index ---');
    context.read<MainBottomNavigationCubit>().changeScreen(index);
  }
}

class BottomNavIcon extends StatelessWidget {
  final String svgIconPath;
  final Color? selectedIconColor;
  final bool showBadge;
  const BottomNavIcon({super.key, required this.svgIconPath, this.selectedIconColor, this.showBadge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 5.0,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: selectedIconColor != null ? AppBoxShadows().primaryBoxShadow : [],
            ),
            child: SvgPicture.asset(
              svgIconPath,
              colorFilter: selectedIconColor != null
                  ? ColorFilter.mode(
                      selectedIconColor!,
                      BlendMode.srcIn,
                    )
                  : const ColorFilter.mode(
                      AppColors.primaryText,
                      BlendMode.srcIn,
                    ),
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            top: 2,
            right: -5,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
