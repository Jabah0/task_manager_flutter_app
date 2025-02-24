import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/router/route_names.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager/features/task/presentation/widgets/priority_badge.dart';
import 'package:task_manager/features/task/presentation/widgets/status_badge.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final currentTask = state is TaskUpdated ? state.task : task;

        return Scaffold(
          appBar: AppBar(title: Text(currentTask.title)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentTask.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Deadline: ${DateFormat('yyyy-MM-dd').format(currentTask.deadline)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.flag, size: 18),
                      const SizedBox(width: 8),
                      const Text("Priority:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      TextButton(
                          onPressed: () =>
                              _showPriorityBottomSheet(context, currentTask),
                          child: _buildPriorityBadge(currentTask)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 18),
                      const SizedBox(width: 8),
                      const Text("Status:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () =>
                            _showStatusBottomSheet(context, currentTask),
                        child: _buildStatusBadge(currentTask),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Description:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentTask.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      context.push(RouteNames.subTasks, extra: currentTask);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Subtasks",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: currentTask.subTasks.map((subtask) {
                      return GestureDetector(
                        onTap: () {
                          context.push(RouteNames.taskDetail, extra: subtask);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black26),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subtask.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPriorityBottomSheet(BuildContext context, TaskEntity currentTask) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final task = (state is TaskUpdated && state.task.id == currentTask.id)
              ? state.task
              : currentTask;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: TaskPriority.values.map((priority) {
                return ListTile(
                  leading: priorityBadge(priority),
                  onTap: () {
                    context.read<TaskBloc>().add(
                          ChangeTaskPriorityEvent(
                            taskId: task.id,
                            newPriority: priority,
                          ),
                        );
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showStatusBottomSheet(BuildContext context, TaskEntity currentTask) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          final task = (state is TaskUpdated && state.task.id == currentTask.id)
              ? state.task
              : currentTask;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: TaskStatus.values.map((status) {
                return ListTile(
                  leading: statusBadge(status),
                  onTap: () {
                    context.read<TaskBloc>().add(
                          ChangeTaskStatusEvent(
                            task.id,
                            status,
                          ),
                        );
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(TaskEntity currentTask) {
    return BlocBuilder<TaskBloc, TaskState>(
      buildWhen: (previous, current) {
        return current is TaskUpdated && current.task.id == currentTask.id;
      },
      builder: (context, state) {
        TaskStatus status = currentTask.status;

        if (state is TaskUpdated && state.task.id == currentTask.id) {
          status = state.task.status;
        }

        return statusBadge(status);
      },
    );
  }

  Widget _buildPriorityBadge(TaskEntity currentTask) {
    return BlocBuilder<TaskBloc, TaskState>(
      buildWhen: (previous, current) {
        return current is TaskUpdated && current.task.id == currentTask.id;
      },
      builder: (context, state) {
        TaskPriority priority = currentTask.priority;

        if (state is TaskUpdated && state.task.id == currentTask.id) {
          priority = state.task.priority;
        }

        return priorityBadge(priority);
      },
    );
  }
}
