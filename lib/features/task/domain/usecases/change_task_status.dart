import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class ChangeTaskStatus
    implements UseCase<Either<Failure, TaskEntity>, ChangeTaskStatusParams> {
  final TaskRepository repository;

  ChangeTaskStatus(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(ChangeTaskStatusParams params) {
    return repository.changeTaskStatus(params.taskId, params.status);
  }
}

class ChangeTaskStatusParams {
  final String taskId;
  final TaskStatus status;

  ChangeTaskStatusParams({required this.taskId, required this.status});
}
