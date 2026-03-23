import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  final List<Map<String, String>> _banners = [
    {
      "title": "John Wick 4",
      "subtitle": "Crime, Thriller",
      "image": "https://picsum.photos/seed/jw4/800/450",
    },
    {
      "title": "The Batman",
      "subtitle": "Action, Crime",
      "image": "https://picsum.photos/seed/batman/800/450",
    },
    {
      "title": "Dune: Part Two",
      "subtitle": "Sci-Fi, Adventure",
      "image": "https://picsum.photos/seed/dune2/800/450",
    },
    {
      "title": "Oppenheimer",
      "subtitle": "Drama, History",
      "image": "https://picsum.photos/seed/oppen/800/450",
    },
    {
      "title": "Spider-Man",
      "subtitle": "Animation, Action",
      "image": "https://picsum.photos/seed/spidey/800/450",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
                  }
                  return Transform.scale(
                    scale: Curves.easeInOut.transform(value),
                    child: child,
                  );
                },
                child: BannerItem(
                  title: banner["title"]!,
                  subtitle: banner["subtitle"]!,
                  imageUrl: banner["image"]!,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.dramaPink
                    : Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BannerItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const BannerItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.network(imageUrl, fit: BoxFit.cover),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: -20,
              child: Opacity(
                opacity: 0.15,
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
              ),
            ),
            // Title and Subtitle
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
