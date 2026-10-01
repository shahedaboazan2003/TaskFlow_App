import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String uid);
  Future<Either<Failure, UserProfileEntity>> createUserProfile(UserProfileEntity user);
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(UserProfileEntity user);
  Future<Either<Failure, void>> deleteUserProfile(String uid);
}
