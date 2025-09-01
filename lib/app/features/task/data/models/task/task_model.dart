import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app/app/shared/enums/task_priority.dart';

import 'converters/time_of_day_json_converter.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

//Model for task
@freezed
@JsonSerializable(explicitToJson: true)
class TaskModel with _$TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.createdAt,
    this.scheduledDate,
    @TimeOfDayJsonConverter() required this.scheduledTime,
    required this.priority,
  });

  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final bool isComplete;

  @override
  final DateTime createdAt;

  @override
  final DateTime? scheduledDate;

  @override
  @TimeOfDayJsonConverter()
  final TimeOfDay scheduledTime;

  @override
  final TaskPriority priority;

  factory TaskModel.fromJson(Map<String, Object?> json) =>
      _$TaskModelFromJson(json);

  Map<String, Object?> toJson() => _$TaskModelToJson(this);
}
