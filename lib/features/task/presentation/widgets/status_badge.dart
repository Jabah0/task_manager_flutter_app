import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';

Widget statusBadge(TaskStatus status) {
  Color bgColor;
  switch (status) {
    case TaskStatus.toDo:
      bgColor = Colors.orange;
      break;
    case TaskStatus.inProgress:
      bgColor = Colors.blue;
      break;
    case TaskStatus.completed:
      bgColor = Colors.green;
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
      status.name.toUpperCase(),
      style: TextStyle(color: bgColor, fontWeight: FontWeight.bold),
    ),
  );
}
