import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return repository.createTask(task);
  }
}
