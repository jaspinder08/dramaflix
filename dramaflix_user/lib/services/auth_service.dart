import 'package:supabase_flutter/supabase_flutter.dart';
import 'network_service.dart';
import 'package:dramaflix/services/logger.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  User? get currentUser => _supabase.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    Log.info('Supabase: Attempting signIn for $email');
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    Log.info('Supabase: signIn successful for ${response.user?.email}');
    return response;
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    Log.info('Supabase: Attempting signUp for $email');
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    Log.info('Supabase: signUp response received for ${response.user?.email}');
    return response;
  }

  Future<bool> checkEmailExists(String email) async {
    Log.info('Supabase: Checking if email exists: $email');
    try {
      final response = await _supabase
          .from('profile')
          .select('id')
          .eq('email', email)
          .maybeSingle();
      final exists = response != null;
      Log.info('Supabase: Email existence check for $email: $exists');
      return exists;
    } catch (e) {
      Log.error('Supabase: Error checking email existence: $e');
      return false;
    }
  }

  Future<void> saveUserData({
    required String userId,
    required String email,
    required String name,
  }) async {
    Log.info('Supabase: Saving user data for $email');
    await _supabase.from('profile').insert({
      'id': userId,
      'email': email,
      'name': name,
    });
    Log.info('Supabase: User data saved successfully');
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Example of using the Dio-based NetworkService for custom API calls.
  Future<void> fetchExtraUserData() async {
    try {
      final dio = NetworkService.instance;
      // This will trigger the LogInterceptor clearly in the debug console.
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/users/1',
      );
      Log.info(
        'Additional user data fetched successfully: ${response.data['name']}',
      );
    } catch (e) {
      Log.error('Failed to fetch additional data: $e');
    }
  }
}
