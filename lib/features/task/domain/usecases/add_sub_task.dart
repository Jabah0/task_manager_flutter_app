import 'package:dartz/dartz.dart';
import 'package:task_manager/core/usecase.dart';
import 'package:task_manager/core/utils/enums/task_priority.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/task_repository.dart';

class AddSubTask implements UseCase<void, AddSubTaskParams> {
  final TaskRepository repository;

  AddSubTask(this.repository);

  @override
  Future<Either<Failure, void>> call(AddSubTaskParams params) {
    return repository.addSubTask(
      params.mainTaskId,
      params.title,
      params.description,
      params.deadline,
      params.priority,
    );
  }
}

class AddSubTaskParams {
  final String mainTaskId;
  String title;
  String description;
  DateTime deadline;
  TaskPriority priority;

  AddSubTaskParams({
    required this.mainTaskId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
  });
}
