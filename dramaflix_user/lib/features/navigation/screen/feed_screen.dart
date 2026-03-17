import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

class FeedScreen extends StatefulWidget {
  final bool isTabActive;
  const FeedScreen({super.key, required this.isTabActive});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _feedItems = [
    {
      'videoPath': 'assets/videos/stories/the_locked_appartment/episode_1.mp4',
      'storyName': 'The Locked Apartment',
      'totalEpisodes': 12,
    },
    {
      'videoPath': 'assets/videos/stories/the_locked_appartment/episode_2.mp4',
      'storyName': 'Shadow of Deception',
      'totalEpisodes': 18,
    },
    {
      'videoPath': 'assets/videos/stories/the_locked_appartment/episode_3.mp4',
      'storyName': 'Eternal Whispers',
      'totalEpisodes': 24,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        allowImplicitScrolling: false,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _feedItems.length,
        itemBuilder: (context, index) {
          final item = _feedItems[index];
          return FeedVideoItem(
            videoPath: item['videoPath'],
            storyName: item['storyName'],
            totalEpisodes: item['totalEpisodes'],
            isActive: widget.isTabActive && _currentIndex == index,
          );
        },
      ),
    );
  }
}

class FeedVideoItem extends StatefulWidget {
  final String videoPath;
  final String storyName;
  final int totalEpisodes;
  final bool isActive;

  const FeedVideoItem({
    super.key,
    required this.videoPath,
    required this.storyName,
    required this.totalEpisodes,
    required this.isActive,
  });

  @override
  State<FeedVideoItem> createState() => _FeedVideoItemState();
}

class _FeedVideoItemState extends State<FeedVideoItem> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(FeedVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !_initialized) {
      _initController();
    }

    if (_initialized) {
      if (widget.isActive) {
        _controller.play();
        setState(() => _isPlaying = true);
      } else {
        _controller.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.asset(widget.videoPath);
    try {
      await _controller.initialize();
      _controller.setLooping(true);
      if (mounted) {
        setState(() => _initialized = true);
        if (widget.isActive) {
          _controller.play();
          setState(() => _isPlaying = true);
        }
      }
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    if (_initialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video
        if (_initialized)
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                  _isPlaying = false;
                } else {
                  _controller.play();
                  _isPlaying = true;
                }
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(color: AppColors.dramaPink),
          ),

        // Gradients
        _buildGradient(Alignment.topCenter, Alignment.bottomCenter, [
          Colors.black.withOpacity(0.7),
          Colors.transparent,
        ], 0.2),
        _buildGradient(Alignment.bottomCenter, Alignment.topCenter, [
          Colors.black.withOpacity(0.9),
          Colors.transparent,
        ], 0.3),

        // Play Icon Overlay
        if (!_isPlaying && _initialized)
          const Center(
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 80,
            ),
          ),

        // UI Top - Story Info
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.storyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    "${widget.totalEpisodes} Episodes",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Side Buttons (Like, Share)
        Positioned(
          right: 16,
          bottom: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            children: [
              _buildSideButton(
                icon: Icons.favorite_border,
                label: "Like",
                onTap: () {},
              ),
              const SizedBox(height: 24),
              _buildSideButton(
                icon: Icons.share_outlined,
                label: "Share",
                onTap: () {},
              ),
            ],
          ),
        ),

        // UI Bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress bar
                if (_initialized)
                  VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: AppColors.dramaPink,
                      bufferedColor: Colors.white24,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                // const SizedBox(height: 8),
                // Time info
                // if (_initialized)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         _formatDuration(_controller.value.position),
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 12,
                //         ),
                //       ),
                //       Text(
                //         _formatDuration(_controller.value.duration),
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 12,
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradient(
    Alignment begin,
    Alignment end,
    List<Color> colors,
    double heightFactor,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      top: begin == Alignment.topCenter ? 0 : null,
      bottom: begin == Alignment.bottomCenter ? 0 : null,
      child: Container(
        height: MediaQuery.of(context).size.height * heightFactor,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: begin, end: end, colors: colors),
        ),
      ),
    );
  }
}
