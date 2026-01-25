import 'package:flutter/material.dart';

import 'package:skye_app/features/auth/auth/welcome_screen.dart';
import 'package:skye_app/features/home/home/home_screen.dart';
import 'package:skye_app/shared/services/auth_service.dart';

/// Uygulama açılışında auth kontrolü. Giriş yapılmışsa [HomeScreen], değilse [WelcomeScreen].
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final loggedIn = snapshot.hasError ? false : (snapshot.data ?? false);
        return loggedIn ? const HomeScreen() : const WelcomeScreen();
      },
    );
  }
}
