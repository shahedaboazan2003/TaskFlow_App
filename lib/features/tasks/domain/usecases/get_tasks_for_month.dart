import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetTasksForMonth {
  final TaskRepository repository;

  GetTasksForMonth(this.repository);

  Stream<Either<Failure, List<TaskEntity>>> call(String userId, DateTime month) {
    return repository.getTasksForMonth(userId, month);
  }
}
