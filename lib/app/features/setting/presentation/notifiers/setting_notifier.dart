import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/utils/fast_hash.dart';
import 'package:todo_app/app/features/setting/data/repository/impl/setting_repository_impl.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';
import 'package:todo_app/app/shared/providers.dart';
import '../../data/models/setting_model.dart';

final settingNotifierProvider =
    AsyncNotifierProvider<SettingNotifier, SettingModel>(SettingNotifier.new);

class SettingNotifier extends AsyncNotifier<SettingModel> {
  late final SettingRepositoryImpl _repository = ref.read(
    settingRepositoryProvider,
  );

  @override
  Future<SettingModel> build() async {
    try {
      return await _repository.getSettings();
    } catch (e) {
      throw Exception('Failed to load settings: $e');
    }
  }

  /// Toggle a single setting
  Future<void> toggleAskBeforeAction(SettingModel settings) async {
    state = const AsyncLoading(); // show loader while saving
    state = await AsyncValue.guard(() async {
      await _repository.updateSetting(settings);
      return settings;
    });
  }

  // Toggles notifications, schedules or cancels task reminders, and updates settings
  Future<void> toggleNotification(bool value) async {
    state = const AsyncLoading(); // show loader while saving

    final settings = state.value!.copyWith(activeNotification: value);
    state = await AsyncValue.guard(() async {
      await ref.read(localNotificationProvider).init();
      if (!value) {
        await ref.read(localNotificationProvider).cancelAll();
      } else {
        final tasks = ref.read(taskListNotifierProvider).value;
        if (tasks != null) {
          for (var i = 0; i < tasks.length; i++) {
            if (tasks[i].scheduledDate == null) {
              await ref
                  .read(localNotificationProvider)
                  .scheduleDailyAtTime(
                    id: fastHash(tasks[i].id),
                    title: 'Task Reminder',
                    body: 'It\'s time to start "${tasks[i].title}"',
                    hour: tasks[i].scheduledTime.hour,
                    minute: tasks[i].scheduledTime.minute,
                  );
            } else {
              await ref
                  .read(localNotificationProvider)
                  .scheduleTaskNotification(
                    id: fastHash(tasks[i].id),
                    title: 'Task Reminder',
                    body: 'It\'s time to start "${tasks[i].title}"',
                    scheduledDate: tasks[i].scheduledDate!.toLocal(),
                    scheduledTime: tasks[i].scheduledTime,
                  );
            }
          }
        }
      }
      await _repository.updateSetting(settings);
      return settings;
    });
  }

  /// You can add more helper methods for other settings later
}
