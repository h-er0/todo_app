import 'package:drift/drift.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';

import '../../database/database.dart';

//Extension on task model to convert it to database insertable
extension TaskCompanionMapper on TaskModel {
  TasksCompanion toCompanion() {
    return TasksCompanion.insert(
      id: Value(id),
      title: title,
      description: description,
      isComplete: isComplete,
      createdAt: createdAt,
      scheduledDate: Value(scheduledDate),
      scheduledTime: scheduledTime,
      priority: priority,
    );
  }
}
