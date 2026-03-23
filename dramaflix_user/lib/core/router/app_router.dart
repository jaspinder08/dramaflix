import 'package:dramaflix/features/auth/screen/email_screen.dart';
import 'package:dramaflix/features/auth/screen/password_screen.dart';
import 'package:dramaflix/features/auth/screen/get_started.dart';
import 'package:dramaflix/features/episodePlayer/episodeplayer.dart';
import 'package:dramaflix/features/navigation/common/watchlist.dart';
import 'package:dramaflix/features/navigation/tabs/main_navigation.dart';
import 'package:dramaflix/features/stories/story.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screen/splash_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.getStarted,
      builder: (context, state) => const GetStarted(),
    ),
    GoRoute(
      path: AppRoutes.emailScreen,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      path: AppRoutes.passwordScreen,
      builder: (context, state) => const PasswordScreen(),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const Navigation(),
    ),
    GoRoute(
      path: AppRoutes.story,
      builder: (context, state) => const StorieMainScreen(),
    ),
    GoRoute(
      path: AppRoutes.episode,
      builder: (context, state) => EpisodePlayer(
        videoAssetPath:
            'assets/videos/stories/the_locked_appartment/episode_1.mp4',
        episodeTitle: 'Episode 1 — The Locked Apartment',
        onBackPressed: () => context.pop(),
      ),
    ),
    GoRoute(
      path: AppRoutes.watchlist,
      builder: (context, state) => const WatchlistScreen(),
    ),
  ],
);
