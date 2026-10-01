import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, TaskEntity>> call(TaskEntity task) {
    return repository.updateTask(task);
  }
}
