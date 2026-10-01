import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<UserEntity?> get authStateStream => remoteDataSource.authStateStream;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return const Left(ServerFailure('Failed to sign out.'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(_mapFirebaseAuthError(e.code)));
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred.'));
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled. Please contact support.';
      default:
        return 'An error occurred during authentication. Please try again.';
    }
  }
}
