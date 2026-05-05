import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/UI/auth/login.dart';

import '../../services/auth_services.dart';
import '../home/home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.value.authStateChanges,
      builder: (context, snapshot) {

        ///Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        ///Logged out
        if (!snapshot.hasData) {
          return LoginScreen();
        }

        ///Logged In
        return HomeScreen();
      },
    );
  }
}