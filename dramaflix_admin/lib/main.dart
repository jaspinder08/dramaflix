import 'package:dramaflix_admin/features/login/admin_login.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dramaflix_shared/dramaflix_shared.dart';

void main() {
  runApp(const ProviderScope(child: AdminDramaFlix()));
}

class AdminDramaFlix extends StatelessWidget {
  const AdminDramaFlix({super.key});

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
