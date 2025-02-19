import 'package:hive/hive.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import '../models/task_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class TaskLocalDataSource {
  List<TaskModel> getTasks();
  void saveTasks(List<TaskModel> tasks);
  void addTask(TaskModel task);
  void addSubTask(String mainTaskId, TaskModel subTask);
  void changeTaskStatus(String taskId, TaskStatus status);
  void changeTaskPriority(String taskId, TaskPriority newPriority);
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
  void addTask(TaskModel task) {
    tasksBox.put(task.id, task.toJson());
  }

  @override
  void addSubTask(String mainTaskId, TaskModel subTask) {
    final mainTask = tasksBox.get(mainTaskId);
    if (mainTask != null) {
      final task = TaskModel.fromJson(tasksBox.get(mainTaskId));
      final updatedSubTasks = [...?task.subTasks, subTask];
      final updatedTask = task.copyWith(subTasks: updatedSubTasks);
      tasksBox.put(mainTaskId, updatedTask);
    } else {
      throw CacheException("Main task not found");
    }
  }

  @override
  void changeTaskStatus(String taskId, TaskStatus status) {
    final cashTask = tasksBox.get(taskId);
    if (cashTask != null) {
      final task = TaskModel.fromJson(cashTask);
      final updatedTask = task.copyWith(status: status);
      tasksBox.put(taskId, updatedTask.toJson());
    } else {
      throw CacheException("Task not found");
    }
  }

  @override
  void changeTaskPriority(String taskId, TaskPriority newPriority) async {
    final cashTask = tasksBox.get(taskId);
    if (cashTask != null) {
      final task = TaskModel.fromJson(cashTask);
      final updatedTask = task.copyWith(priority: newPriority);
      tasksBox.put(taskId, updatedTask);
    } else {
      throw CacheException("Task not found");
    }
  }

  @override
  void deleteTask(String taskId) {
    tasksBox.delete(taskId);
  }
}
