import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/usecases/add_sub_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';

import '../../../../core/usecase.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/change_task_status.dart';
import '../../domain/usecases/change_task_priority.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final AddSubTask addSubTask;
  final ChangeTaskStatus changeTaskStatus;
  final ChangeTaskPriority changeTaskPriority;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.addSubTask,
    required this.changeTaskStatus,
    required this.changeTaskPriority,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<AddTaskEvent>(_onAddNewTask);
    on<AddSubTaskEvent>(_onAddNewSubTask);
    on<ChangeTaskStatusEvent>(_onChangeTaskStatus);
    on<ChangeTaskPriorityEvent>(_onChangeTaskPriority);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(
      LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTasks(NoParams());

    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (tasks) => emit(TaskLoaded(tasks: tasks)),
    );
  }

  Future<void> _onAddNewTask(
      AddTaskEvent event, Emitter<TaskState> emit) async {
    final result = await addTask(AddTaskParams(
      title: event.title,
      description: event.description,
      deadline: event.deadline,
      priority: event.priority,
    ));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => add(LoadTasksEvent()),
    );
  }

  Future<void> _onChangeTaskStatus(
      ChangeTaskStatusEvent event, Emitter<TaskState> emit) async {
    final result = await changeTaskStatus(
        ChangeTaskStatusParams(taskId: event.taskId, status: event.newStatus));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (task) {
        emit(TaskUpdated(task: task));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onChangeTaskPriority(
      ChangeTaskPriorityEvent event, Emitter<TaskState> emit) async {
    final result = await changeTaskPriority(ChangeTaskPriorityParams(
      taskId: event.taskId,
      newPriority: event.newPriority,
    ));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (task) {
        emit(TaskUpdated(task: task));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onAddNewSubTask(
      AddSubTaskEvent event, Emitter<TaskState> emit) async {
    final result = await addSubTask(AddSubTaskParams(
      mainTaskId: event.mainTaskId,
      title: event.title,
      description: event.description,
      deadline: event.deadline,
      priority: event.priority,
    ));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (task) {
        emit(TaskUpdated(task: task));
        add(LoadTasksEvent());
      },
    );
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    final result = await deleteTask(DeleteTaskParams(taskId: event.taskId));
    result.fold(
      (failure) => emit(TaskError(message: failure.message)),
      (_) => add(LoadTasksEvent()),
    );
  }
}
