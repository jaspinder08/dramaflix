import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingService {
  static const String _key = 'hasSeenOnboarding';
  final SharedPreferences _prefs;

  OnboardingService(this._prefs);

  bool hasSeenOnboarding() {
    return _prefs.getBool(_key) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_key, value);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingService(prefs);
});
