import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfile {
  final UserRepository repository;

  UpdateUserProfile(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(UserProfileEntity user) {
    return repository.updateUserProfile(user);
  }
}
