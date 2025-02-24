import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';

Widget priorityBadge(TaskPriority priority) {
  Color bgColor;
  switch (priority) {
    case TaskPriority.low:
      bgColor = Colors.green;
      break;
    case TaskPriority.medium:
      bgColor = Colors.orange;
      break;
    case TaskPriority.high:
      bgColor = Colors.red;
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: bgColor.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: bgColor, width: 1.5),
    ),
    child: Text(
      priority.name.toUpperCase(),
      style: TextStyle(color: bgColor, fontWeight: FontWeight.bold),
    ),
  );
}
