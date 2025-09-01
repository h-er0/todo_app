import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/app/config/routes/app_router.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('App launches and shows home', (WidgetTester tester) async {
    final appRouter = AppRouter(initialLocation: Routes.taskList);

    // Build l'app avec l'appRouter
    await tester.pumpWidget(MyApp(appRouter: appRouter));

    // Vérifie si MaterialApp existe
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
