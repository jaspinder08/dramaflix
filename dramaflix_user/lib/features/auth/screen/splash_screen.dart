import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:video_player/video_player.dart';
import '../../../providers/splash_provider.dart';
import '../../../services/logger.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/logo.mp4');

    try {
      await _controller.initialize();

      _controller.setVolume(0); // 🔴 Important fix
      _controller.setLooping(false);

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      _controller.play();

      _controller.addListener(_videoListener);
    } catch (e) {
      Log.error('Video initialization failed: $e');
      _navigateToNext();
    }
  }

  void _videoListener() async {
    if (_controller.value.position >= _controller.value.duration) {
      _controller.removeListener(_videoListener);

      // Start fade out
      if (mounted) {
        setState(() {
          _isFadingOut = true;
        });
      }

      // Small delay after video ends for smoothness (e.g., 1 second)
      await Future.delayed(const Duration(milliseconds: 1000));

      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    final nextLocation = await ref.read(splashProvider).getNextLocation();
    if (mounted) {
      context.go(nextLocation);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: _isInitialized
            ? AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _isFadingOut ? 0.0 : 1.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            : const CircularProgressIndicator(color: AppColors.dramaPink),
      ),
    );
  }
}
