import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/constants/app_colors.dart';

// ──────────────────────────────────────────────────────────────────
// EpisodePlayer
// A full-portrait (9:16) video player that loads from Flutter assets.
// ──────────────────────────────────────────────────────────────────

class EpisodePlayer extends StatefulWidget {
  /// Path to the video asset, e.g.
  /// "assets/videos/stories/the_locked_appartment/episode_1.mp4"
  final String videoAssetPath;
  final String episodeTitle;
  final VoidCallback onBackPressed;

  const EpisodePlayer({
    super.key,
    required this.videoAssetPath,
    required this.episodeTitle,
    required this.onBackPressed,
  });

  @override
  State<EpisodePlayer> createState() => _EpisodePlayerState();
}

class _EpisodePlayerState extends State<EpisodePlayer>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;

  bool _initialized = false;
  bool _hasError = false;
  bool _showControls = true;

  Timer? _hideTimer;

  // ── Lifecycle ──────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    // Lock to portrait while in the player
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.asset(widget.videoAssetPath);

    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      _controller.addListener(_onVideoUpdate);
      if (mounted) {
        setState(() => _initialized = true);
        _scheduleHide();
      }
    } catch (e) {
      debugPrint('[EpisodePlayer] init error: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onVideoUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.removeListener(_onVideoUpdate);
    _controller.dispose();
    // Restore orientation when leaving
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  // ── Controls logic ─────────────────────────────────────────────

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _handleTap() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _scheduleHide();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _hideTimer?.cancel();
        _showControls = true;
      } else {
        _controller.play();
        _scheduleHide();
      }
    });
  }

  void _seek(Duration target) {
    _controller.seekTo(target);
    _scheduleHide();
  }

  // ── Helpers ────────────────────────────────────────────────────

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Video surface ──────────────────────────────────
            _VideoSurface(controller: _controller, initialized: _initialized),

            // ── Gradient overlays ──────────────────────────────
            _buildTopGradient(),
            _buildBottomGradient(),

            // ── Loading / error states ─────────────────────────
            if (!_initialized && !_hasError)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.dramaPink,
                  ),
                ),
              ),

            if (_hasError)
              const Center(
                child: Text(
                  'Could not load video.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),

            // ── Buffering indicator ────────────────────────────
            if (_initialized && _controller.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.dramaPink,
                  ),
                ),
              ),

            // ── Controls overlay (fades in/out) ────────────────
            if (_initialized)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: _ControlsOverlay(
                    controller: _controller,
                    episodeTitle: widget.episodeTitle,
                    onBackPressed: widget.onBackPressed,
                    onPlayPause: _togglePlayPause,
                    onSeek: _seek,
                    formatDuration: _fmt,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Gradient helpers ───────────────────────────────────────────

  Widget _buildTopGradient() => Positioned(
    top: 0,
    left: 0,
    right: 0,
    height: 160,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.85), Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
  );

  Widget _buildBottomGradient() => Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    height: 220,
    child: DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.95)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
  );
}

// ──────────────────────────────────────────────────────────────────
// _VideoSurface — renders the video, centred and cover-fitted
// ──────────────────────────────────────────────────────────────────

class _VideoSurface extends StatelessWidget {
  const _VideoSurface({required this.controller, required this.initialized});

  final VideoPlayerController controller;
  final bool initialized;

  @override
  Widget build(BuildContext context) {
    if (!initialized) return const SizedBox.expand();

    final videoAspect = controller.value.aspectRatio; // e.g. 9/16 ≈ 0.5625
    final screenSize = MediaQuery.of(context).size;
    final screenAspect = screenSize.width / screenSize.height;

    // Scale so the video always fills (cover) the screen
    double scale;
    if (screenAspect > videoAspect) {
      // Screen is wider than the video → scale so height fills
      scale = screenAspect / videoAspect;
    } else {
      scale = videoAspect / screenAspect;
    }

    return Transform.scale(
      scale: scale,
      child: Center(
        child: AspectRatio(
          aspectRatio: videoAspect,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// _ControlsOverlay — top bar + centre play/pause + bottom bar
// ──────────────────────────────────────────────────────────────────

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({
    required this.controller,
    required this.episodeTitle,
    required this.onBackPressed,
    required this.onPlayPause,
    required this.onSeek,
    required this.formatDuration,
  });

  final VideoPlayerController controller;
  final String episodeTitle;
  final VoidCallback onBackPressed;
  final VoidCallback onPlayPause;
  final void Function(Duration) onSeek;
  final String Function(Duration) formatDuration;

  @override
  Widget build(BuildContext context) {
    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Stack(
      children: [
        // ── Top bar ─────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: onBackPressed,
                ),
                const SizedBox(width: 4),
                // Episode title
                Expanded(
                  child: Text(
                    episodeTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Centre play / pause ──────────────────────────────────
        Center(
          child: GestureDetector(
            onTap: onPlayPause,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
              child: Icon(
                controller.value.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ),
        ),

        // ── Bottom bar ───────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time row
                  Row(
                    children: [
                      Text(
                        formatDuration(position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '  /  ',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                      Text(
                        formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Seekable progress bar
                  _SeekBar(
                    progress: progress,
                    onSeek: (ratio) {
                      final target = Duration(
                        milliseconds: (ratio * duration.inMilliseconds).round(),
                      );
                      onSeek(target);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// _SeekBar — custom draggable progress bar
// ──────────────────────────────────────────────────────────────────

class _SeekBar extends StatefulWidget {
  const _SeekBar({required this.progress, required this.onSeek});
  final double progress;
  final void Function(double ratio) onSeek;

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  double? _dragProgress;

  double get _displayProgress => _dragProgress ?? widget.progress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final ratio = (details.localPosition.dx / box.size.width).clamp(
          0.0,
          1.0,
        );
        setState(() => _dragProgress = ratio);
      },
      onHorizontalDragEnd: (_) {
        if (_dragProgress != null) {
          widget.onSeek(_dragProgress!);
          setState(() => _dragProgress = null);
        }
      },
      onTapUp: (details) {
        final box = context.findRenderObject() as RenderBox;
        final ratio = (details.localPosition.dx / box.size.width).clamp(
          0.0,
          1.0,
        );
        widget.onSeek(ratio);
      },
      child: SizedBox(
        height: 20,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Track background
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Filled portion
            FractionallySizedBox(
              widthFactor: _displayProgress,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.dramaPink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Thumb
            FractionallySizedBox(
              widthFactor: _displayProgress,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: const BoxDecoration(
                    color: AppColors.dramaPink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
