import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    // These should be moved to a constants file or environment variables
    await Supabase.initialize(
      url: 'https://wxzqncvzabqmzqwjxmgj.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4enFuY3Z6YWJxbXpxd2p4bWdqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwMzY5ODMsImV4cCI6MjA4ODYxMjk4M30.z__KMvkPzSKvz-n_XmOpX7JitCL5ZdY75ZPTO-1Glg8',
      debug: true,
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}
