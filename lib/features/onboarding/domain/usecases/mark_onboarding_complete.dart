import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../repositories/onboarding_repository.dart';

class MarkOnboardingComplete {
  final OnboardingRepository repository;

  MarkOnboardingComplete(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.markOnboardingComplete();
  }
}
