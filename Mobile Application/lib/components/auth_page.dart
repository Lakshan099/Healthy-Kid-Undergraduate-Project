import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_kid_app/Screens/login_screen.dart';
import 'package:healthy_kid_app/Screens/welcome_screen.dart';
import 'package:healthy_kid_app/components/main_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return WelcomeScreen();
            } else {
              return MainScreen();
            }
          }),
    );
  }
}
