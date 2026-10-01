import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksByDate {
  final TaskRepository repository;

  GetTasksByDate(this.repository);

  Stream<Either<Failure, List<TaskEntity>>> call(String userId, DateTime date) {
    return repository.getTasksByDate(userId, date);
  }
}
