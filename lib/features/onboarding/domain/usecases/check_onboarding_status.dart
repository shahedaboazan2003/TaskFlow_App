import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/onboarding_repository.dart';

class CheckOnboardingStatus {
  final OnboardingRepository repository;

  CheckOnboardingStatus(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.checkOnboardingStatus();
  }
}
