import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTaskParams {
  final String taskId;

  DeleteTaskParams({required this.taskId});
}

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) {
    return repository.deleteTask(params.taskId);
  }
}
