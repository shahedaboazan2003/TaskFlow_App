import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String uid) async {
    try {
      final user = await remoteDataSource.getUserProfile(uid);
      return Right(user);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> createUserProfile(
      UserProfileEntity user) async {
    try {
      final createdUser =
          await remoteDataSource.createUserProfile(UserModel.fromEntity(user));
      return Right(createdUser);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
      UserProfileEntity user) async {
    try {
      final updatedUser =
          await remoteDataSource.updateUserProfile(UserModel.fromEntity(user));
      return Right(updatedUser);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserProfile(String uid) async {
    try {
      await remoteDataSource.deleteUserProfile(uid);
      return const Right(null);
    } catch (e) {
      return Left(_mapFirestoreError(e));
    }
  }

  Failure _mapFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return const ServerFailure(
              'You do not have permission to perform this action.');
        case 'unavailable':
          return const ServerFailure(
              'Service temporarily unavailable. Please check your connection.');
        case 'not-found':
          return const ServerFailure('User not found.');
        case 'deadline-exceeded':
          return const ServerFailure('Request timed out. Please try again.');
        case 'resource-exhausted':
          return const ServerFailure('Too many requests. Please wait a moment.');
        default:
          return const ServerFailure('An error occurred. Please try again.');
      }
    }
    return const ServerFailure('An unexpected error occurred. Please try again.');
  }
}
