import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app/services/local_notification_service.dart';

final contentShiftedStateProvider = StateProvider<bool>((ref) => false);

final askBeforActionStateProvider = StateProvider<bool>((ref) => true);

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final localNotificationProvider = StateProvider<LocalNotification>(
  (ref) => LocalNotification(),
);
