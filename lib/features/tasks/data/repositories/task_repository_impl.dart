import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Stream<Either<Failure, List<TaskEntity>>> getTasks(String userId) {
    return remoteDataSource.getTasks(userId).map(
      (tasks) => Right<Failure, List<TaskEntity>>(tasks),
    ).handleError((error) {
      return Left<Failure, List<TaskEntity>>(_mapFirestoreError(error));
    });
  }

  @override
  Stream<Either<Failure, List<TaskEntity>>> getTasksByDate(String userId, DateTime date) {
    return remoteDataSource.getTasksByDate(userId, date).map(
      (tasks) => Right<Failure, List<TaskEntity>>(tasks),
    ).handleError((error) {
      return Left<Failure, List<TaskEntity>>(_mapFirestoreError(error));
    });
  }

  @override
  Stream<Either<Failure, List<TaskEntity>>> getTasksForMonth(String userId, DateTime month) {
    return remoteDataSource.getTasksForMonth(userId, month).map(
      (tasks) => Right<Failure, List<TaskEntity>>(tasks),
    ).handleError((error) {
      return Left<Failure, List<TaskEntity>>(_mapFirestoreError(error));
    });
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String taskId) async {
    try {
      final task = await remoteDataSource.getTaskById(taskId);
      return Right(task);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final createdTask = await remoteDataSource.createTask(TaskModel.fromEntity(task));
      return Right(createdTask);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final updatedTask = await remoteDataSource.updateTask(TaskModel.fromEntity(task));
      return Right(updatedTask);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> toggleTaskCompletion(String taskId) async {
    try {
      final updatedTask = await remoteDataSource.toggleTaskCompletion(taskId);
      return Right(updatedTask);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> changeTaskStatus(String taskId, String status) async {
    try {
      final updatedTask = await remoteDataSource.changeTaskStatus(taskId, status);
      return Right(updatedTask);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  Failure _mapFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return const ServerFailure('PERMISSION_DENIED: You do not have permission to perform this action. Firestore rules may not be deployed.');
        case 'unauthenticated':
          return const ServerFailure('UNAUTHENTICATED: Please sign in again.');
        case 'failed-precondition':
          return const ServerFailure('FAILED_PRECONDITION: A required Firestore index is missing. Check the Firebase Console for index creation links.');
        case 'invalid-argument':
          return const ServerFailure('INVALID_ARGUMENT: Invalid data provided.');
        case 'not-found':
          return const ServerFailure('NOT_FOUND: Task not found.');
        case 'already-exists':
          return const ServerFailure('ALREADY_EXISTS: This task already exists.');
        case 'deadline-exceeded':
          return const ServerFailure('DEADLINE_EXCEEDED: Request timed out. Please try again.');
        case 'unavailable':
          return const ServerFailure('UNAVAILABLE: Service temporarily unavailable. Please check your connection.');
        case 'resource-exhausted':
          return const ServerFailure('RESOURCE_EXHAUSTED: Too many requests. Please wait a moment.');
        default:
          return ServerFailure('FIRESTORE_ERROR [${error.code}]: ${error.message ?? 'An error occurred.'}');
      }
    }
    return const ServerFailure('An unexpected error occurred. Please try again.');
  }
}
