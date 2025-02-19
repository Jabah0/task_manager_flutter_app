import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import 'package:task_manager/core/utils/enums/task_status.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class ChangeTaskStatus implements UseCase<void, ChangeTaskStatusParams> {
  final TaskRepository repository;

  ChangeTaskStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeTaskStatusParams params) {
    return repository.changeTaskStatus(params.taskId, params.status);
  }
}

class ChangeTaskStatusParams {
  final String taskId;
  final TaskStatus status;

  ChangeTaskStatusParams({required this.taskId, required this.status});
}
