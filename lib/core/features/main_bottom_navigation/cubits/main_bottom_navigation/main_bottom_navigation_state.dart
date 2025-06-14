part of 'main_bottom_navigation_cubit.dart';

class MainBottomNavigationState {
  final MainBottomNavigationScreens currentScreen;

  const MainBottomNavigationState({required this.currentScreen});

  MainBottomNavigationState copyWith({MainBottomNavigationScreens? currentScreen}) {
    return MainBottomNavigationState(currentScreen: currentScreen ?? this.currentScreen);
  }
}
