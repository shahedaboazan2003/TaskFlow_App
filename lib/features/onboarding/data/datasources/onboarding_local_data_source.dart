import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> checkOnboardingStatus();
  Future<void> markOnboardingComplete();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _onboardingKey = 'ONBOARDING_COMPLETED';

  OnboardingLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> checkOnboardingStatus() async {
    return sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  @override
  Future<void> markOnboardingComplete() async {
    await sharedPreferences.setBool(_onboardingKey, true);
  }
}
