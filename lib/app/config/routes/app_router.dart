import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/app/core/errors/not_found.dart';
import 'package:todo_app/app/features/task/presentation/views/nav_bar_view.dart';
import 'package:todo_app/app/features/setting/presentation/views/setting_view.dart';
import 'package:todo_app/app/features/task/presentation/views/task_list_view.dart';

import '../../features/task/presentation/views/add_task_view.dart';
import '../../features/task/presentation/views/edit_task_view.dart';
import '../../shared/globals.dart';

part 'app_routes.dart';

class AppRouter {
  final GoRouter _router;

  AppRouter({required String initialLocation})
    : _router = GoRouter(
        navigatorKey: rootNavigatorKey,
        initialLocation: initialLocation,
        routes: [
          GoRoute(
            path: _Paths.notFound,
            builder: (BuildContext context, GoRouterState state) {
              return NotFoundPage(uri: state.extra as String? ?? '');
            },
          ),

          StatefulShellRoute(
            builder: (context, state, navigationShell) {
              return navigationShell;
            },
            navigatorContainerBuilder:
                (
                  BuildContext context,
                  StatefulNavigationShell navigationShell,
                  List<Widget> children,
                ) {
                  return NavBarView(
                    navigationShell: navigationShell,
                    children: children,
                  );
                },
            branches: <StatefulShellBranch>[
              StatefulShellBranch(
                navigatorKey: taskNavigatorKey,
                routes: [
                  GoRoute(
                    path: _Paths.taskList,
                    builder: (context, state) =>
                        TaskListView(key: state.pageKey),
                    routes: [
                      GoRoute(
                        path: _Paths.addTask,
                        builder: (context, state) {
                          return AddTaskView();
                        },
                      ),
                      GoRoute(
                        path: _Paths.editTask,
                        builder: (context, state) {
                          final extra = state.extra as Map<String, dynamic>;

                          return EditTaskView(task: extra["task"]);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              StatefulShellBranch(
                navigatorKey: settingNavigatorKey,
                routes: [
                  GoRoute(
                    path: _Paths.settings,
                    builder: (context, state) =>
                        SettingView(key: state.pageKey),
                  ),
                ],
              ),
            ],
          ),
        ],
        redirect: (BuildContext context, GoRouterState state) async {
          logger.i("Navigate to ${state.uri}");
          return null;
        },
        onException: (_, GoRouterState state, GoRouter router) {
          router.push(_Paths.notFound, extra: state.uri.toString());
        },
      );

  GoRouter get router => _router;
}
