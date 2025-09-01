import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/core/utils/fast_hash.dart';
import 'package:todo_app/app/features/setting/presentation/notifiers/setting_notifier.dart';
import 'package:todo_app/app/features/task/data/repository/impl/task_repository_impl.dart';
import 'package:todo_app/app/shared/globals.dart';
import 'package:todo_app/app/shared/providers.dart';

import '../../data/models/task/task_model.dart';

final taskListNotifierProvider =
    AsyncNotifierProvider<TaskListNotifier, List<TaskModel>>(
      () => TaskListNotifier(),
    );

class TaskListNotifier extends AsyncNotifier<List<TaskModel>> {
  @override
  FutureOr<List<TaskModel>> build() async {
    state = const AsyncLoading();
    final tasks = await _repository.getTasks();
    return tasks;
  }

  Future<void> completeAll(List<String> ids) async {
    await _repository.completeAll(ids);
    //Remove the scheduled notification when a task is complete
    if (ref.read(settingNotifierProvider).value?.activeNotification == true) {
      for (var i = 0; i < ids.length; i++) {
        try {
          await ref.read(localNotificationProvider).cancel(fastHash(ids[i]));
        } catch (e) {
          logger.e("Can't cancel shceduled notification for: ${ids[i]}");
        }
      }
    }
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
  }

  late final TaskRepositoryImpl _repository = ref.read(taskRepositoryProvider);
}
