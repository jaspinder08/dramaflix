import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../../core/router/app_routes.dart';
import '../../../services/onboarding_service.dart';

class GetStarted extends ConsumerStatefulWidget {
  const GetStarted({super.key});

  @override
  ConsumerState<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends ConsumerState<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/get_started_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 0.8, 1.0],
                  colors: [
                    AppColors.black.withOpacity(0.3),
                    AppColors.transperant,
                    AppColors.background.withOpacity(0.8),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  AppLogo(),
                  const SizedBox(height: 20),

                  Text(
                    "Unlimited Dramas,\nInfinite Stories.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Watch premium short-form dramas anywhere, anytime. Your next favorite story is just a tap away.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppButton(
                    text: "Get Started",
                    onPressed: () async {
                      await ref
                          .read(onboardingServiceProvider)
                          .setHasSeenOnboarding(true);
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        context.push(AppRoutes.emailScreen);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
