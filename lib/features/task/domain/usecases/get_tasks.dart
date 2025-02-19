import 'package:dartz/dartz.dart';
import 'package:task_manager/core/errors/failures.dart';
import 'package:task_manager/core/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks extends UseCase<Either<Failure, List<TaskEntity>>, NoParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) async {
    return repository.getTasks();
  }
}
