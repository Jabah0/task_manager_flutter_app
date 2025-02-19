import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class AddTaskParams {
  final String title;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;

  AddTaskParams({
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
  });
}

class AddTask implements UseCase<void, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<Failure, void>> call(AddTaskParams params) {
    return repository.addTask(
      params.title,
      params.description,
      params.deadline,
      params.priority,
    );
  }
}
