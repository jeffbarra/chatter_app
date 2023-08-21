import 'package:chatter/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginOrRegister> {
// Initially, show the login page
  bool showLoginPage = true;

// Toggle between login and register page
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onPressed: togglePage);
    } else {
      return SignUpPage(onPressed: togglePage);
    }
  }
}
