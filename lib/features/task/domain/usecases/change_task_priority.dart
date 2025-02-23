import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import 'package:task_manager/features/task/domain/entities/task.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class ChangeTaskPriority
    implements UseCase<Either<Failure, TaskEntity>, ChangeTaskPriorityParams> {
  final TaskRepository repository;

  ChangeTaskPriority(this.repository);

  @override
  Future<Either<Failure, TaskEntity>> call(ChangeTaskPriorityParams params) {
    return repository.changeTaskPriority(params.taskId, params.newPriority);
  }
}

class ChangeTaskPriorityParams {
  final String taskId;
  final TaskPriority newPriority;

  ChangeTaskPriorityParams({required this.taskId, required this.newPriority});
}
