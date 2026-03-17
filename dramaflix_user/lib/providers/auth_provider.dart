import 'package:dramaflix/models/auth.dart';
import 'package:dramaflix/services/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';

// ──────────────────────────────────────────────
// Infrastructure providers
// ──────────────────────────────────────────────

final supabaseServiceProvider = Provider((ref) => SupabaseService());

final authServiceProvider = Provider((ref) {
  final supabase = ref.watch(supabaseServiceProvider);
  return AuthService(supabase.client);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges.map((_) => auth.currentUser);
});

// ──────────────────────────────────────────────
// AuthNotifier
// ──────────────────────────────────────────────

class AuthNotifier extends StateNotifier<AuthStateData> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(AuthStateData());

  // ── Helpers ──────────────────────────────────

  AuthService get _authService => _ref.read(authServiceProvider);

  // ── UI helpers ───────────────────────────────

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  // ── checkEmail ───────────────────────────────

  /// Checks whether [email] already has an account.
  /// Returns `true` if the e-mail exists, `false` otherwise.
  Future<bool> checkEmail(String email) async {
    Log.info('[AuthNotifier] checkEmail → start (email: $email)');
    state = state.copyWith(
      isLoading: true,
      error: null,
      email: email,
      emailExists: null,
    );

    try {
      final exists = await _authService.checkEmailExists(email);
      Log.info('[AuthNotifier] checkEmail → success (exists: $exists)');
      state = state.copyWith(emailExists: exists);
      return exists;
    } catch (e) {
      Log.error('[AuthNotifier] checkEmail → error: $e');
      state = state.copyWith(
        error: 'Unable to verify email. Please try again.',
      );
      return false;
    } finally {
      Log.info('[AuthNotifier] checkEmail → finally (resetting isLoading)');
      state = state.copyWith(isLoading: false);
    }
  }

  // ── signIn ───────────────────────────────────

  /// Signs the user in with [password] and the e-mail already stored in state.
  /// Returns `true` on success.
  Future<bool> signIn(String password) async {
    if (state.email == null) {
      Log.warning('[AuthNotifier] signIn → aborted (no email in state)');
      state = state.copyWith(
        error: 'No e-mail provided. Please go back and enter your e-mail.',
      );
      return false;
    }

    Log.info('[AuthNotifier] signIn → start (email: ${state.email})');
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.signIn(email: state.email!, password: password);
      Log.info('[AuthNotifier] signIn → success');
      return true;
    } on AuthApiException catch (e) {
      Log.error(
        '[AuthNotifier] signIn → AuthApiException (${e.statusCode} | ${e.code}): ${e.message}',
      );

      final userMessage = switch (e.code) {
        'invalid_credentials' => 'Incorrect password. Please try again.',
        'email_not_confirmed' =>
          'Please verify your email address before signing in.',
        'user_not_found' =>
          'No account found with this email. Please sign up first.',
        _ => 'Sign-in failed: ${e.message}',
      };

      state = state.copyWith(error: userMessage);
      return false;
    } catch (e) {
      Log.error('[AuthNotifier] signIn → unexpected error: $e');
      state = state.copyWith(error: 'Something went wrong. Please try again.');
      return false;
    } finally {
      Log.info('[AuthNotifier] signIn → finally (resetting isLoading)');
      state = state.copyWith(isLoading: false);
    }
  }

  // ── signUp ───────────────────────────────────

  /// Creates a new account with [password] and the e-mail already stored in state.
  /// Returns `true` on success.
  Future<bool> signUp(String password) async {
    if (state.email == null) {
      Log.warning('[AuthNotifier] signUp → aborted (no email in state)');
      state = state.copyWith(
        error: 'No e-mail provided. Please go back and enter your e-mail.',
      );
      return false;
    }

    Log.info('[AuthNotifier] signUp → start (email: ${state.email})');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.signUp(
        email: state.email!,
        password: password,
      );

      if (response.user != null) {
        Log.info(
          '[AuthNotifier] signUp → saving profile for ${response.user!.email}',
        );
        await _authService.saveUserData(
          userId: response.user!.id,
          email: state.email!,
          name: state.name ?? 'User',
        );
        Log.info('[AuthNotifier] signUp → success');
      } else {
        // Supabase returned no user — treat as soft failure.
        Log.warning(
          '[AuthNotifier] signUp → response contained no user object',
        );
        state = state.copyWith(error: 'Sign-up failed. Please try again.');
        return false;
      }

      return true;
    } on AuthApiException catch (e) {
      Log.error(
        '[AuthNotifier] signUp → AuthApiException (${e.statusCode} | ${e.code}): ${e.message}',
      );

      if (e.code == 'user_already_exists') {
        // Account already exists — flip emailExists so the UI immediately
        // shows "Login" / "Welcome Back" labels, then delegate to signIn.
        Log.info(
          '[AuthNotifier] signUp → user already exists, updating state & falling through to signIn',
        );
        state = state.copyWith(
          isLoading: false,
          emailExists: true, // ← drives "Login" button label in PasswordScreen
          error: null,
        );
        return await signIn(password);
      }

      final userMessage = switch (e.code) {
        'email_address_invalid' =>
          'The email address is not valid. Please check and try again.',
        'weak_password' =>
          'Password is too weak. Please choose a stronger password.',
        _ => 'Registration failed: ${e.message}',
      };

      state = state.copyWith(error: userMessage);
      return false;
    } catch (e) {
      Log.error('[AuthNotifier] signUp → unexpected error: $e');
      state = state.copyWith(error: 'Something went wrong. Please try again.');
      return false;
    } finally {
      Log.info('[AuthNotifier] signUp → finally (resetting isLoading)');
      state = state.copyWith(isLoading: false);
    }
  }

  // ── signOut ──────────────────────────────────

  /// Signs the current user out and resets [AuthStateData] to its defaults.
  /// Returns `true` on success.
  Future<bool> signOut() async {
    Log.info('[AuthNotifier] signOut → start');
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.signOut();
      Log.info('[AuthNotifier] signOut → success, resetting state');
      state = AuthStateData(); // full reset
      return true;
    } catch (e) {
      Log.error('[AuthNotifier] signOut → error: $e');
      state = state.copyWith(error: 'Sign-out failed. Please try again.');
      return false;
    } finally {
      Log.info('[AuthNotifier] signOut → finally (resetting isLoading)');
      // Guard: if signOut succeeded we already replaced state entirely —
      // only apply the patch when state is not already a fresh AuthStateData.
      if (state.isLoading) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}

// ──────────────────────────────────────────────
// Provider registration
// ──────────────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  return AuthNotifier(ref);
});
