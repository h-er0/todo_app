import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/app/features/task/data/data_sources/task_local_data_source.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/features/task/data/repository/interfaces/task_repository.dart';

/// Provider for TaskRepository implementation.
final taskRepositoryProvider = Provider<TaskRepositoryImpl>(
  (ref) => TaskRepositoryImpl(localDataSource: TaskLocalDataSource()),
);

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(TaskModel task) async {
    await localDataSource.addTask(task);
  }

  @override
  Future<void> editTask(TaskModel task) async {
    await localDataSource.editTask(task);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    return await localDataSource.getTasks();
  }

  @override
  Future<void> completeAll(List<String> ids) async {
    await localDataSource.completeAll(ids);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }
}
