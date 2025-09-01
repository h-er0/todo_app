import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/utils/fast_hash.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/features/task/data/repository/impl/task_repository_impl.dart';
import 'package:todo_app/app/features/task/presentation/notifiers/task_list_notifier.dart';
import 'package:todo_app/app/shared/globals.dart';
import 'package:todo_app/app/shared/enums/task_priority.dart';
import 'package:todo_app/app/shared/providers.dart';

import '../../../setting/presentation/notifiers/setting_notifier.dart';

//Provider for adding task.
final addTaskNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AddTaskNotifier, void>(
      AddTaskNotifier.new,
    );

class AddTaskNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  late final TaskRepositoryImpl _repository = ref.read(taskRepositoryProvider);

  //Adds a new task with the given parameters.
  Future<void> addTask(
    String title,
    String description,
    TaskPriority priority,
    DateTime? scheduledDate,
    TimeOfDay scheduledTime,
  ) async {
    state = const AsyncLoading();

    final task = TaskModel(
      id: uuid.v4(),
      title: title,
      description: description,
      isComplete: false,
      createdAt: DateTime.now().toUtc(),
      scheduledDate: scheduledDate?.toUtc(),
      scheduledTime: scheduledTime,
      priority: priority,
    );

    state = await AsyncValue.guard(() => _repository.addTask(task));
    //Schedule task to notify user
    if (ref.read(settingNotifierProvider).value?.activeNotification == true) {
      if (task.scheduledDate == null) {
        //Schedule task daily at the scheduledTime if scheduledDate isnt provided
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
        //Schedule task at the provided scheduledDate and scheduledTime
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
