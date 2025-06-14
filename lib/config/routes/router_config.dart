import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/routes/route_names.dart';
import 'package:flutter_template_app/core/features/authentication/cubits/auth/auth_cubit.dart';

class RouterState {
  late AuthCubit authCubit;
  // Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
  GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');
  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNavigatorKey');
  String initialRoute = RouteNames.homePage;

  static final RouterState _instance = RouterState._internal();

  /// We need to reset keys on every hot reload to avoid error 'Multiple widgets used the same GlobalKey...'
  resetKeys() {
    rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNavigatorKey');
    homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNavigatorKey');
  }

  /// Need to set initial route based on the auth state so when the app starts
  /// we need to show splash screen on AuthInitial state
  setInitialRoute() {
    if (authCubit.state is Authenticated) {
      initialRoute = RouteNames.homePage;
    } else if (authCubit.state is Unauthenticated) {
      initialRoute = RouteNames.landingPage;
    } else {
      initialRoute = RouteNames.initialScreen;
    }
    // print('------- setInitialRoute CALLED! $initialRoute -----');
  }

  initializeRouteState() {
    resetKeys();
    setInitialRoute();
  }

  factory RouterState() {
    return _instance;
  }
  RouterState._internal();
}
