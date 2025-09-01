import 'package:flutter/material.dart';
import '../../shared/enums/task_priority.dart';

//📌 Extension to Add Color Based on Priority
extension TaskPriorityX on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  String get label {
    switch (this) {
      case TaskPriority.low:
        return "Low";
      case TaskPriority.medium:
        return "Medium";
      case TaskPriority.high:
        return "High";
    }
  }
}
