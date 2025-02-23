import 'package:dartz/dartz.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import '../../../../core/errors/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, TaskEntity>> addTask(
    String title,
    String description,
    DateTime deadline,
    TaskPriority priority,
  );
  Future<Either<Failure, TaskEntity>> addSubTask(
    String mainTaskId,
    String title,
    String description,
    DateTime deadline,
    TaskPriority priority,
  );
  Future<Either<Failure, TaskEntity>> changeTaskStatus(
      String taskId, TaskStatus status);
  Future<Either<Failure, TaskEntity>> changeTaskPriority(
      String taskId, TaskPriority newPriority);
  Future<Either<Failure, void>> deleteTask(String taskId);
}
