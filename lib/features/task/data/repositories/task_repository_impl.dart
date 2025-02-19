import 'package:dartz/dartz.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/data/datasources/task_local_data_source.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final tasks = localDataSource.getTasks();
      return Right(tasks);
    } catch (e) {
      return Left(DatabaseFailure("Failed to load tasks"));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(
    String title,
    String description,
    DateTime deadline,
    TaskPriority priority,
  ) async {
    try {
      final taskModel = TaskModel(
        id: Uuid().v4(),
        title: title,
        description: description,
        deadline: deadline,
        priority: priority,
        status: TaskStatus.toDo,
        subTasks: [],
        isMain: true,
      );
      localDataSource.addTask(taskModel);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to add task"));
    }
  }

  @override
  Future<Either<Failure, void>> addSubTask(
    String mainTaskId,
    String title,
    String description,
    DateTime deadline,
    TaskPriority priority,
  ) async {
    try {
      localDataSource.addSubTask(
          mainTaskId,
          TaskModel(
            id: Uuid().v4(),
            title: title,
            description: description,
            deadline: deadline,
            priority: priority,
            status: TaskStatus.toDo,
            isMain: false,
          ));
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to add sub-task"));
    }
  }

  @override
  Future<Either<Failure, void>> changeTaskStatus(
    String taskId,
    TaskStatus status,
  ) async {
    try {
      localDataSource.changeTaskStatus(taskId, status);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to change task status"));
    }
  }

  @override
  Future<Either<Failure, void>> changeTaskPriority(
    String taskId,
    TaskPriority newPriority,
  ) async {
    try {
      localDataSource.changeTaskPriority(taskId, newPriority);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to change task priority"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      localDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to delete task"));
    }
  }
}
