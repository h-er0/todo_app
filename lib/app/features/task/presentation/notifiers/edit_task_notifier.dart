import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/features/setting/presentation/notifiers/setting_notifier.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/features/task/data/repository/impl/task_repository_impl.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';

import '../../../../core/utils/fast_hash.dart';
import '../../../../shared/providers.dart';

//Provider for edit task
final editTaskNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EditTaskNotifier, void>(
      EditTaskNotifier.new,
    );

class EditTaskNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  late final TaskRepositoryImpl _repository = ref.read(taskRepositoryProvider);

  //Edit an existing task
  Future<void> editTask(TaskModel task) async {
    // Indicate that an async operation is running
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.editTask(task));
    //Re-schedule task to notify user.
    if (ref.read(settingNotifierProvider).value?.activeNotification == true) {
      if (task.scheduledDate == null) {
        await ref
            .read(localNotificationProvider)
            .scheduleDailyAtTime(
              id: fastHash(task.id),
              title: "Task reminder",
              body: 'It\'s time to start "${task.title}"',
              hour: task.scheduledTime.hour,
              minute: task.scheduledTime.minute,
            );
      } else {
        await ref
            .read(localNotificationProvider)
            .scheduleTaskNotification(
              id: fastHash(task.id),
              title: "Task reminder",
              body: 'It\'s time to start "${task.title}"',
              scheduledDate: task.scheduledDate!.toLocal(),
              scheduledTime: task.scheduledTime,
            );
      }
    }
        //Refresh the task list
    ref.invalidate(taskListNotifierProvider);
  }
}
