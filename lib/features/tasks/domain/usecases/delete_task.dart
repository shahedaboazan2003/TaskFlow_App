import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<Either<Failure, void>> call(String taskId) {
    return repository.deleteTask(taskId);
  }
}
