import 'package:dramaflix_shared/dramaflix_shared.dart';
import 'package:flutter/material.dart';
import '../main/main_layout.dart';

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
              AppLogo(),
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
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
