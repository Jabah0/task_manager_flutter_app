import 'package:flutter/material.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';

class SubTasksScreen extends StatelessWidget {
  final TaskEntity parentTask;

  const SubTasksScreen({super.key, required this.parentTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${parentTask.title} - Subtasks")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: parentTask.subTasks.length,
        itemBuilder: (context, index) {
          final subTask = parentTask.subTasks[index];
          return ListTile(
            leading: Checkbox(
              value: subTask.status == TaskStatus.completed,
              onChanged: (value) {
                // TODO: Implement Bloc event to update subtask completion
              },
            ),
            title: Text(subTask.title),
          );
        },
      ),
    );
  }
}
