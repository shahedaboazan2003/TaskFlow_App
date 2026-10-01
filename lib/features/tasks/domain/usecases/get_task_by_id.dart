import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTaskById {
  final TaskRepository repository;

  GetTaskById(this.repository);

  Future<Either<Failure, TaskEntity>> call(String taskId) {
    return repository.getTaskById(taskId);
  }
}
