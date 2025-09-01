import 'package:drift/drift.dart';
import 'package:todo_app/app/features/task/data/models/task/task_model.dart';
import 'package:todo_app/app/shared/enums/task_priority.dart';

import '../../shared/globals.dart';
import '../converters/time_of_day_type_converter.dart';

@UseRowClass(TaskModel)
class Tasks extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v4())();

  TextColumn get title => text()();

  TextColumn get description => text()();

  BoolColumn get isComplete => boolean()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get scheduledDate => dateTime().nullable()();

  IntColumn get scheduledTime =>
      integer().map(const TimeOfDayTypeConverter())();

  IntColumn get priority => intEnum<TaskPriority>()();

  @override
  Set<Column> get primaryKey => {id}; // Marking `id` as the primary key
}
