import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_app/core/features/main_bottom_navigation/enums/main_bottom_navigation_screens.dart';
part 'main_bottom_navigation_state.dart';

class MainBottomNavigationCubit extends Cubit<MainBottomNavigationState> {
  MainBottomNavigationCubit() : super(const MainBottomNavigationState(currentScreen: MainBottomNavigationScreens.home));

  /// This is a method used to change the main bottom navigation screen from anywhere in the app
  ///
  /// [int] `screen` is the screen that will be switched to
  changeScreen(int screen) {
    try {
      MainBottomNavigationScreens currentScreen = MainBottomNavigationScreens.values.elementAt(screen);
      emit(state.copyWith(currentScreen: currentScreen));
      // print('--- changeScreen $currentScreen ---');
    } catch (e) {
      debugPrint('--- changeScreen FAILED $e ---');
    }
  }
}
