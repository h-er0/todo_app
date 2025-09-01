import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// A JsonConverter for `TimeOfDay` objects, used with `json_serializable`.
///
/// Converts a `TimeOfDay` instance to a `String` for JSON storage
/// and parses a `String` back into a `TimeOfDay`.
/// The expected string format is "HH:mm", e.g., "14:30".
class TimeOfDayJsonConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayJsonConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  String toJson(TimeOfDay object) {
    return '${object.hour.toString().padLeft(2, '0')}:${object.minute.toString().padLeft(2, '0')}';
  }
}
