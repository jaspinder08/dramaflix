import 'episode.dart';

class Story {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String? trailerUrl;
  final String category;
  final List<Episode> episodes;

  Story({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    this.trailerUrl,
    required this.category,
    this.episodes = const [],
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    var episodeList = json['episodes'] as List? ?? [];
    List<Episode> episodes = episodeList
        .map((e) => Episode.fromJson(e as Map<String, dynamic>))
        .toList();

    return Story(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      trailerUrl: json['trailer_url'] as String?,
      category: json['category'] as String,
      episodes: episodes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'trailer_url': trailerUrl,
      'category': category,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
