import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';
import '../../../core/router/app_routes.dart';
import '../../../providers/auth_provider.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final authState = ref.read(authProvider);
      final isNewUser = authState.emailExists == false;
      final password = _passwordController.text.trim();

      bool success;
      if (isNewUser) {
        success = await ref.read(authProvider.notifier).signUp(password);
      } else {
        success = await ref.read(authProvider.notifier).signIn(password);
      }

      if (mounted && success) {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isNewUser = authState.emailExists == false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  isNewUser ? "Create Account" : "Welcome Back",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isNewUser
                      ? "Set a password for ${authState.email}"
                      : "Enter your password for ${authState.email}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                AppTextField(
                  controller: _passwordController,
                  label: "Password",
                  hintText: "••••••••",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  obscureText: authState.obscurePassword,
                  onToggleVisibility: () => ref
                      .read(authProvider.notifier)
                      .togglePasswordVisibility(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (isNewUser && value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: isNewUser ? "Sign Up" : "Login",
                  isLoading: authState.isLoading,
                  onPressed: _handleSubmit,
                ),
                if (authState.error != null) ...[
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
