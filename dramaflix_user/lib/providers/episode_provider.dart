import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/episode.dart';
import 'story_provider.dart';

final currentEpisodeProvider = StateProvider<Episode?>((ref) => null);

final nextEpisodeProvider = Provider<Episode?>((ref) {
  final currentEpisode = ref.watch(currentEpisodeProvider);
  if (currentEpisode == null) return null;

  final storyId = currentEpisode.storyId;
  final storyAsync = ref.watch(storyDetailsProvider(storyId));

  return storyAsync.when(
    data: (story) {
      final currentIndex = story.episodes.indexWhere(
        (e) => e.id == currentEpisode.id,
      );
      if (currentIndex != -1 && currentIndex < story.episodes.length - 1) {
        return story.episodes[currentIndex + 1];
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
