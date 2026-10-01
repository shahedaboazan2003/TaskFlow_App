import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(String uid) {
    return repository.getUserProfile(uid);
  }
}
