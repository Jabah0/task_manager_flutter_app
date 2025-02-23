import 'package:task_manager/core/utils/enums/task_status.dart';

import '../../domain/entities/task.dart';
import '../../../../core/utils/enums/task_priority.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.deadline,
    required super.priority,
    required super.status,
    required super.isMain,
    super.subTasks = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      priority: TaskPriorityExtension.fromJson(json['priority'] as String),
      status: TaskStatusExtension.fromJson(json['status'] as String),
      isMain: json['isMain'] as bool,
      subTasks: (json['subTasks'] as List<dynamic>? ?? [])
          .map((subTaskJson) =>
              TaskModel.fromJson(subTaskJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority.toJson(),
      'status': status.toJson(),
      'isMain': isMain,
      'subTasks':
          subTasks.whereType<TaskModel>().map((task) => task.toJson()).toList(),
    };
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    TaskPriority? priority,
    TaskStatus? status,
    bool? isMain,
    List<TaskEntity>? subTasks,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isMain: isMain ?? this.isMain,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}
