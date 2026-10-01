import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<Either<Failure, List<TaskEntity>>> call(String userId) {
    return repository.getTasks(userId);
  }
}
