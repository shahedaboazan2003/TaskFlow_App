import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class ChangeTaskStatus {
  final TaskRepository repository;

  ChangeTaskStatus(this.repository);

  Future<Either<Failure, TaskEntity>> call(String taskId, String status) {
    return repository.changeTaskStatus(taskId, status);
  }
}
