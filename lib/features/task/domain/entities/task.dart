import 'package:equatable/equatable.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import '../../../../core/utils/enums/task_priority.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  final TaskStatus status;
  final List<TaskEntity>? subTasks;
  final bool isMain;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.status,
    this.subTasks = const [],
    required this.isMain,
  });

  @override
  List<Object?> get props =>
      [id, title, description, deadline, priority, status, subTasks, isMain];
}
