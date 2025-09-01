import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

//Converter to convert the time of day to an integer supported by the database
class TimeOfDayTypeConverter extends TypeConverter<TimeOfDay, int> {
  const TimeOfDayTypeConverter();

  @override
  TimeOfDay fromSql(int fromDb) {
    final hour = fromDb ~/ 60;
    final minute = fromDb % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  int toSql(TimeOfDay value) {
    return value.hour * 60 + value.minute;
  }
}
