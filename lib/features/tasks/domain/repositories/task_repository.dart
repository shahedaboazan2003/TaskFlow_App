import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Stream<Either<Failure, List<TaskEntity>>> getTasks(String userId);
  Stream<Either<Failure, List<TaskEntity>>> getTasksByDate(String userId, DateTime date);
  Stream<Either<Failure, List<TaskEntity>>> getTasksForMonth(String userId, DateTime month);
  Future<Either<Failure, TaskEntity>> getTaskById(String taskId);
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, TaskEntity>> toggleTaskCompletion(String taskId);
  Future<Either<Failure, TaskEntity>> changeTaskStatus(String taskId, String status);
}
