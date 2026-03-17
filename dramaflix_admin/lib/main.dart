import 'package:flutter/material.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DramaFlix Admin',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AdminLoginScreen(),
    );
  }
}

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'DramaFlix Admin',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.dramaPink,
                ),
              ),
              const SizedBox(height: 48),
              AppTextField(
                controller: _emailController,
                label: 'Admin Email',
                prefixIcon: Icons.admin_panel_settings_outlined,
                hintText: 'admin@dramaflix.com',
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                obscureText: true,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Login to Dashboard',
                onPressed: () {
                  // Admin login logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
