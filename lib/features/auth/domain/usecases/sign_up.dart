import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    return await repository.signUpWithEmailAndPassword(email, password);
  }
}
