import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_app/config/routes/route_names.dart';
import 'package:flutter_template_app/config/routes/router_config.dart';
import 'package:flutter_template_app/core/features/authentication/cubits/auth/auth_cubit.dart';
import 'package:flutter_template_app/core/features/authentication/view/initial_screen.dart';
import 'package:flutter_template_app/core/features/authentication/view/landing_page/landing_page.dart';
import 'package:flutter_template_app/core/features/authentication/view/login_page/login_page.dart';
import 'package:flutter_template_app/core/utils/stream_to_listenable.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter _goRouterInstance = GoRouter(
    navigatorKey: RouterState().rootNavigatorKey,
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: StreamToListenable([RouterState().authCubit.stream]),
    redirect: (context, GoRouterState state) {
      // print(
      //     '======= GO_ROUTER state changed ====== ${context.read<AuthCubit>().state} -> redirectToHomeInitialy ${context.read<AuthCubit>().redirectToHomeInitialy}');

      if (context.read<AuthCubit>().state is Unauthenticated) {
        // Pages available for users that are not logged in
        switch (state.fullPath) {
          case RouteNames.signupPage:
            return RouteNames.signupPage;
          case RouteNames.loginPage:
            return RouteNames.loginPage;
          case RouteNames.resetPassword:
            return RouteNames.resetPassword;

          default:
            return RouteNames.landingPage;
        }
      }

      if (context.read<AuthCubit>().state is Authenticated && context.read<AuthCubit>().redirectToHomeInitialy) {
        context.read<AuthCubit>().redirectToHomeInitialy = false;
        // return RouteNames.homePage;
      }

      return null;
    },
    initialLocation: RouterState().initialRoute,
    routes: <RouteBase>[
      // Splash screen used to cover loading gap on app startup
      GoRoute(
        path: RouteNames.initialScreen,
        builder: (context, state) {
          return const InitialScreen();
        },
      ),
      // TODO: Implement landing page with Upgrader
      GoRoute(
        path: RouteNames.landingPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            // child: UpgradeAlert(
            //   showIgnore: false,
            //   showLater: false,
            //   showReleaseNotes: false,
            //   upgrader: Upgrader(
            //     durationUntilAlertAgain: const Duration(seconds: 1),
            //     debugLogging: true,
            //     storeController: UpgraderStoreController(
            //       onAndroid: () => UpgraderAppcastStore(appcastURL: Environment.appCastUrl),
            //     ),
            //   ),
            child: const LandingPage(),
            // ),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              // Change the opacity of the screen using a Curve based on the the animation's
              // value
              // return FadeTransition(
              //   opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              //   child: child,
              // );
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteNames.loginPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionDuration: const Duration(milliseconds: 250),
            transitionsBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation, Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      // This are the routes of pages displayed as a content of the bottom navigation
      // StatefulShellRoute.indexedStack(
      //   builder: (context, state, navigationShell) {
      //     // Return the widget that implements the custom shell (BottomNavigationBar).
      //     // The [StatefulNavigationShell] is passed to be able to navigate to other branches in a stateful way.
      //     return BottomNavigationFrame(navigationShell);
      //   },
      //   branches: [
      //     // The route branch for the 1º Tab
      //     StatefulShellBranch(
      //       navigatorKey: RouterState().homeNavigatorKey,
      //       routes: const <RouteBase>[
      //         // Add this branch routes
      //         // each routes with its sub routes if available e.g shope/uuid/details
      //         // GoRoute(
      //         //   path: RouteNames.homePage,
      //         //   builder: (context, state) => UpgradeAlert(
      //         //       showIgnore: false,
      //         //       showLater: false,
      //         //       showReleaseNotes: false,
      //         //       upgrader: Upgrader(
      //         //         durationUntilAlertAgain: const Duration(seconds: 1),
      //         //         debugLogging: true,
      //         //         storeController: UpgraderStoreController(
      //         //           onAndroid: () => UpgraderAppcastStore(appcastURL: Environment.appCastUrl),
      //         //         ),
      //         //       ),
      //         //       child: HomePage()),
      //         // ),
      //       ],
      //     ),
      //   ],
      // ),
    ],
  );

  GoRouter get goRouterInstance => _goRouterInstance;
}
