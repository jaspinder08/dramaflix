import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/router/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/onboarding_service.dart';

final splashProvider = Provider((ref) => SplashController(ref));

class SplashController {
  final Ref _ref;

  SplashController(this._ref);

  Future<String> getNextLocation() async {
    // 1. Check if Supabase session exists
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      return AppRoutes.home;
    }

    // 2. If no session, check onboarding flag
    final onboardingService = _ref.read(onboardingServiceProvider);
    final hasSeenOnboarding = onboardingService.hasSeenOnboarding();

    if (!hasSeenOnboarding) {
      return AppRoutes.getStarted;
    }

    // 3. If onboarding completed, go to Email Screen
    return AppRoutes.emailScreen;
  }
}
