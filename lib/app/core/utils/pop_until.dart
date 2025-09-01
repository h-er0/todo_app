import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//A function to close the entire screen until the provided route.
//The provided route must be present in the navigation stack
void popUntilPath(BuildContext context, String routePath, {bool? replace}) {
  while (GoRouter.of(
        context,
      ).routerDelegate.currentConfiguration.matches.last.matchedLocation !=
      routePath) {
    if (!context.canPop()) {
      return;
    }
    debugPrint('Popping $routePath');
    if (replace != null) {
      context.pop(replace);
    } else {
      context.pop();
    }
  }
}
