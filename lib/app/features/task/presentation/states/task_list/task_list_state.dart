import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';

part 'task_list_state.freezed.dart';

/// Represents the state of the task list in the application.
@freezed
abstract class TaskListState with _$TaskListState {
  const factory TaskListState({required List<TaskModel> tasks}) =
      _TaskListState;
}
