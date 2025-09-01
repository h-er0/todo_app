import 'package:todo_app/app/features/task/data/models/task/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> editTask(TaskModel task);
  Future<void> completeAll(List<String> ids);
  Future<void> deleteTask(String id);
}
