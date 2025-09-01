import 'package:drift/drift.dart';
import 'package:todo_app/app/core/extensions/task_to_companion.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/shared/globals.dart';

/// Local data source responsible for all CRUD operations on tasks.
/// Uses Drift database through `drift.managers.tasks`.
class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks() async {
    try {
      return await drift.managers.tasks.get();
    } catch (e, st) {
      logger.e('Error getting tasks: $e\n$st');
      throw 'Failed to get tasks';
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await drift.managers.tasks.create((f) => task.toCompanion());
    } catch (e, st) {
      logger.e('Error adding task: $e\n$st');
      throw 'Failed to add task';
    }
  }

  Future<void> editTask(TaskModel task) async {
    try {
      final updatedCount = await drift.managers.tasks
          .filter((f) => f.id(task.id))
          .update((f) => task.toCompanion());

      if (updatedCount == 0) {
        // Task with the given ID was not found in the database
        throw ('Task not found for id: ${task.id}');
      }
    } catch (e, st) {
      logger.e('Error editing task: $e\n$st');
      throw 'Failed to edit task';
    }
  }

  Future<void> completeAll(List<String> ids) async {
    try {
      await drift.managers.tasks
          .filter((f) => f.id.isIn(ids))
          .update((f) => f(isComplete: Value(true)));
    } catch (e, st) {
      logger.e('Error completing tasks: $e\n$st');
      throw ('Failed to complete tasks');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final deletedCount = await drift.managers.tasks
          .filter((f) => f.id(id))
          .delete();

      if (deletedCount == 0) {
        // Task with the given ID was not found in the database
        throw 'Task not found for id: $id';
      }
    } catch (e, st) {
      logger.e('Error deleting task: $e\n$st');
      throw 'Failed to delete task';
    }
  }
}
