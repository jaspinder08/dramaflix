import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../services/story_service.dart';
import 'auth_provider.dart';

final storyServiceProvider = Provider((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return StoryService(supabase.client);
});

final storiesProvider = FutureProvider<List<Story>>((ref) async {
  return ref.watch(storyServiceProvider).getStories();
});

final storyDetailsProvider = FutureProvider.family<Story, String>((
  ref,
  id,
) async {
  return ref.watch(storyServiceProvider).getStoryDetails(id);
});
