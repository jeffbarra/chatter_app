import 'package:chatter/auth/login_or_register.dart';
import 'package:chatter/pages/auth/login_page.dart';
import 'package:chatter/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // listens for changes in auth state
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
// If user IS logged in
          if (snapshot.hasData) {
            return const HomePage();
          }
// If user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
