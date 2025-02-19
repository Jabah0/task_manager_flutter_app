part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;

  AddTaskEvent({
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
  });

  @override
  List<Object> get props => [title, description, deadline, priority];
}

class AddSubTaskEvent extends TaskEvent {
  final String mainTaskId;
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;

  AddSubTaskEvent({
    required this.mainTaskId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
  });

  @override
  List<Object> get props =>
      [mainTaskId, title, description, deadline, priority];
}

class ChangeTaskStatusEvent extends TaskEvent {
  final String taskId;
  final TaskStatus newStatus;

  ChangeTaskStatusEvent(this.taskId, this.newStatus);

  @override
  List<Object> get props => [taskId];
}

class ChangeTaskPriorityEvent extends TaskEvent {
  final String taskId;
  final TaskPriority newPriority;

  ChangeTaskPriorityEvent({required this.taskId, required this.newPriority});

  @override
  List<Object> get props => [taskId, newPriority];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}
