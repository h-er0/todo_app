// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  isComplete: json['isComplete'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  scheduledDate: json['scheduledDate'] == null
      ? null
      : DateTime.parse(json['scheduledDate'] as String),
  scheduledTime: const TimeOfDayJsonConverter().fromJson(
    json['scheduledTime'] as String,
  ),
  priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'isComplete': instance.isComplete,
  'createdAt': instance.createdAt.toIso8601String(),
  'scheduledDate': instance.scheduledDate?.toIso8601String(),
  'scheduledTime': const TimeOfDayJsonConverter().toJson(
    instance.scheduledTime,
  ),
  'priority': _$TaskPriorityEnumMap[instance.priority]!,
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};
