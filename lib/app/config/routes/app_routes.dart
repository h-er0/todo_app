part of 'app_router.dart';

abstract class Routes {
  Routes._();

  static const String notFound = _Paths.notFound;
  static const String taskList = _Paths.taskList;
  static const String addTask = _Paths.addTask;
  static const String editTask = _Paths.editTask;
  static const String archived = _Paths.archived;
  static const String settings = _Paths.settings;
}

abstract class _Paths {
  _Paths._();

  static const String notFound = '/404';
  static const String taskList = '/taskList';
  static const String addTask = '/addTask';
  static const String editTask = '/editTask';
  static const String archived = '/archived';
  static const String settings = '/settings';
}
