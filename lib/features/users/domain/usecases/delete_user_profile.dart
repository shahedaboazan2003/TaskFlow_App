import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repository.dart';

class DeleteUserProfile {
  final UserRepository repository;

  DeleteUserProfile(this.repository);

  Future<Either<Failure, void>> call(String uid) {
    return repository.deleteUserProfile(uid);
  }
}
