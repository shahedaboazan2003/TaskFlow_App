import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> checkOnboardingStatus();
  Future<Either<Failure, void>> markOnboardingComplete();
}
