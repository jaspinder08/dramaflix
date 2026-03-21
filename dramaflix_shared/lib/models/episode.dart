class Episode {
  final String id;
  final String storyId;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationInSeconds;
  final int order;

  Episode({
    required this.id,
    required this.storyId,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.durationInSeconds,
    required this.order,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      storyId: json['story_id'] as String,
      title: json['title'] as String,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      durationInSeconds: json['duration_in_seconds'] as int,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'story_id': storyId,
      'title': title,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'duration_in_seconds': durationInSeconds,
      'order': order,
    };
  }
}
