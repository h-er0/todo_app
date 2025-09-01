import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:todo_app/app/shared/globals.dart';
import 'package:todo_app/app/shared/providers.dart';

import 'app/config/routes/app_router.dart';
import 'app/config/theme/app_theme.dart';
import 'app/database/database.dart';
import 'app/features/setting/presentation/notifiers/setting_notifier.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <- Important

  //Timezone initialization
  tz.initializeTimeZones();
  timezone.setLocalLocation(timezone.local);

  //Initialize app router and set initial route
  final appRouter = AppRouter(initialLocation: Routes.taskList);
  drift = AppDatabase();

  // Preload settings
  await container.read(settingNotifierProvider.notifier).build();

  //Init notifications
  container.read(localNotificationProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,

      child: MyApp(appRouter: appRouter),
    ),
  );
}

// This widget is the root of your application.
class MyApp extends StatefulHookConsumerWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightThemeData,
      darkTheme: AppTheme.darkThemeData,
      themeMode: ThemeMode.light,
      routerConfig: widget.appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
