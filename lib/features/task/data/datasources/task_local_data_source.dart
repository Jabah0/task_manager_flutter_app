import 'package:hive/hive.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import '../models/task_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class TaskLocalDataSource {
  List<TaskModel> getTasks();
  void saveTasks(List<TaskModel> tasks);
  TaskEntity addTask(TaskModel task);
  TaskEntity addSubTask(String mainTaskId, TaskModel subTask);
  TaskEntity changeTaskStatus(String taskId, TaskStatus status);
  TaskEntity changeTaskPriority(String taskId, TaskPriority newPriority);
  void deleteTask(String taskId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final Box tasksBox;

  TaskLocalDataSourceImpl({required this.tasksBox});

  @override
  List<TaskModel> getTasks() {
    List<TaskModel> tasks = [];
    tasksBox.read(() {
      for (int i = 0; i < tasksBox.length; i++) {
        tasks.add(TaskModel.fromJson(tasksBox.getAt(i)));
      }
    });
    return tasks;
  }

  @override
  void saveTasks(List<TaskModel> tasks) {
    tasksBox.clear();
    tasksBox.write(() {
      for (var task in tasks) {
        tasksBox.put(task.id, task);
      }
    });
  }

  @override
  TaskEntity addTask(TaskModel task) {
    tasksBox.put(task.id, task.toJson());
    return task;
  }

  @override
  TaskEntity addSubTask(String mainTaskId, TaskModel subTask) {
    final mainTask = tasksBox.get(mainTaskId);
    if (mainTask != null) {
      final task = TaskModel.fromJson(tasksBox.get(mainTaskId));
      final updatedSubTasks = [...task.subTasks, subTask];
      final updatedTask = task.copyWith(subTasks: updatedSubTasks);
      tasksBox.put(mainTaskId, updatedTask);
      return updatedTask;
    } else {
      throw CacheException("Main task not found");
    }
  }

  @override
  TaskEntity changeTaskStatus(String taskId, TaskStatus status) {
    final cashTask = tasksBox.get(taskId);
    if (cashTask != null) {
      final task = TaskModel.fromJson(cashTask);
      final updatedTask = task.copyWith(status: status);
      tasksBox.put(taskId, updatedTask.toJson());
      return updatedTask;
    } else {
      throw CacheException("Task not found");
    }
  }

  @override
  TaskEntity changeTaskPriority(String taskId, TaskPriority newPriority) {
    final cashTask = tasksBox.get(taskId);
    if (cashTask != null) {
      final task = TaskModel.fromJson(cashTask);
      final updatedTask = task.copyWith(priority: newPriority);
      tasksBox.put(taskId, updatedTask);
      return updatedTask;
    } else {
      throw CacheException("Task not found");
    }
  }

  @override
  void deleteTask(String taskId) {
    tasksBox.delete(taskId);
  }
}
