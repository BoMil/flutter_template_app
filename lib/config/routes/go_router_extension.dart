import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExt on GoRouter {
  void popUntilPath(String routePath) {
    List routeStacks = [...routerDelegate.currentConfiguration.routes];

    try {
      for (int i = routeStacks.length - 1; i >= 0; i--) {
        RouteBase route = routeStacks[i];
        if (route is GoRoute) {
          if (route.path == routePath) break;
          if (i != 0 && routeStacks[i - 1] is ShellRoute) {
            RouteMatchList matchList = routerDelegate.currentConfiguration;
            restore(matchList.remove(matchList.matches.last));
          } else {
            pop();
          }
        }
      }
    } catch (e) {
      debugPrint('Error in popUntilPath: $e');
    }
  }
}
