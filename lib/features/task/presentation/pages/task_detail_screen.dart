import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import '../bloc/task_bloc.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Deadline: ${DateFormat('yyyy-MM-dd HH:mm').format(task.deadline)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Priority Selection
            Row(
              children: [
                const Icon(Icons.flag, size: 18),
                const SizedBox(width: 8),
                const Text("Priority:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showPriorityBottomSheet(context),
                  child: _buildPriorityBadge(task.priority),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Status Selection
            Row(
              children: [
                const Icon(Icons.check_circle, size: 18),
                const SizedBox(width: 8),
                const Text("Status:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _showStatusBottomSheet(context),
                  child: _buildStatusBadge(task.status),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Description:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPriorityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskPriority.values.map((priority) {
            return ListTile(
              title: Text(priority.name.toUpperCase()),
              leading: _buildPriorityBadge(priority),
              onTap: () {
                context.read<TaskBloc>().add(
                      ChangeTaskPriorityEvent(
                          taskId: task.id, newPriority: priority),
                    );
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            return ListTile(
              title: Text(status.name.toUpperCase()),
              leading: _buildStatusBadge(status),
              onTap: () {
                context
                    .read<TaskBloc>()
                    .add(ChangeTaskStatusEvent(task.id, status));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
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

  Widget _buildStatusBadge(TaskStatus status) {
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
}
