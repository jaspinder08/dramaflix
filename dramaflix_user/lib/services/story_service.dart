import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/story.dart';

class StoryService {
  final SupabaseClient _supabase;

  StoryService(this._supabase);

  Future<List<Story>> getStories() async {
    final response = await _supabase.from('stories').select('*, episodes(*)');
    return (response as List).map((json) => Story.fromJson(json)).toList();
  }

  Future<Story> getStoryDetails(String id) async {
    final response = await _supabase
        .from('stories')
        .select('*, episodes(*)')
        .eq('id', id)
        .single();
    return Story.fromJson(response);
  }
}
