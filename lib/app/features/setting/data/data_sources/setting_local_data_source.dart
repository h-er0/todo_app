import 'dart:convert';

import 'package:todo_app/app/shared/globals.dart';
import 'package:todo_app/app/shared/providers.dart';

import '../models/setting_model.dart';

// Manages local storage for settings using SharedPreferences
class SettingLocalDataSource {
  Future<SettingModel> getSettings() async {
    final prefs = await container.read(sharedPreferencesProvider.future);
    final data = prefs.getString('settings');
    if (data != null) {
      return SettingModel.fromJson(jsonDecode(data));
    } else {
      final localNotification = container.read(localNotificationProvider);
      final settings = SettingModel(
        askBeforeAction: true,
        activeNotification:
            localNotification.permissionGranted &&
            (localNotification.exactAlarmsPermission ?? true),
      );
      await prefs.setString('settings', jsonEncode(settings.toJson()));
      return settings;
    }
  }

  Future<void> updateSetting(SettingModel settings) async {
    final prefs = await container.read(sharedPreferencesProvider.future);
    try {
      await prefs.setString('settings', jsonEncode(settings.toJson()));
    } catch (e) {
      // Handle error, e.g., log or rethrow
      throw Exception('Failed to save setting: $e');
    }
  }
}
