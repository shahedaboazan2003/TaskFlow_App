import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../../../users/domain/repositories/user_repository.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignUp(this.authRepository, this.userRepository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    final result = await authRepository.signUpWithEmailAndPassword(email, password);
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        // Create user profile in Firestore at users/{uid}
        final profile = UserProfileEntity(
          uid: user.id,
          name: '',
          email: user.email,
          createdAt: DateTime.now(),
        );
        final profileResult = await userRepository.createUserProfile(profile);
        return profileResult.fold(
          (failure) => Left(failure),
          (_) => Right(user),
        );
      },
    );
  }
}
