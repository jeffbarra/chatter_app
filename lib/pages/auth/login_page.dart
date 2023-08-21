import 'package:chatter/components/text_field.dart';
import 'package:chatter/widgets/buttons/google_auth_button.dart';
import 'package:chatter/widgets/buttons/login_register_button.dart';
import 'package:chatter/widgets/forgot_password_footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/password_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onPressed;
  const LoginPage({super.key, required this.onPressed});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
// Text Editing Controllers
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

// Sign User In
  void signIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor)));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // pop the loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      // display error message
      displayMessage(e.code);
    }
  }

// Display a dialog message to the user
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Oops!',
                textAlign: TextAlign.center,
              ),
              content: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                // Welcome Image
                Image.asset(
                  'lib/assets/images/login.png',
                ),
                const SizedBox(
                  height: 30,
                ),
                // Welcome Back Message
                Text('Welcome Back!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                const SizedBox(
                  height: 20,
                ),
                // Email Textfield
                MyTextField(
                  controller: emailTextController,
                  hintText: 'Enter Email',
                  obscureText: false,
                  prefixIcon: Icons.email,
                ),

                const SizedBox(
                  height: 10,
                ),

                // Password Textfield
                MyPasswordField(
                  controller: passwordTextController,
                ),

                // Forgot Password
                const ForgotPasswordFooter(),

                // Sign Button
                LoginRegisterButton(text: 'Login', onPressed: signIn),

                const SizedBox(
                  height: 20,
                ),

                // Google Button
                GoogleAuthButton(text: 'Sign In with Google', onPressed: () {}),

                const SizedBox(height: 20),

                // Go to Register Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700)),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: Text('Register now',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600))),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
