import 'package:chatter/components/password_field.dart';
import 'package:chatter/components/text_field.dart';
import 'package:chatter/widgets/buttons/google_auth_button.dart';
import 'package:chatter/widgets/buttons/login_register_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onPressed;
  const SignUpPage({super.key, required this.onPressed});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
// Text Editing Controllers
  final fullNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

// Sign User Up
  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      ),
    );

    // error handlers
    try {
// Create the User
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);

      // after creating the user, create new collection called "users"
      FirebaseFirestore.instance
          // create the collection
          .collection('users')
          // create doc for userCredential
          .doc(userCredential.user!.email)
          // set 'username' -> text before @ sign in email
          .set({
        'username': emailTextController.text.split('@')[0],
        // set 'bio'
        'bio': 'Enter your bio here...'
      });
      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      // show error to user
      displayMessage(e.code);
    }
  }

// Display a dialog message
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
                  'lib/assets/images/register.png',
                ),
                const SizedBox(
                  height: 30,
                ),
                // Welcome Back Message
                Text('Hello There!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor)),
                const SizedBox(
                  height: 20,
                ),

                // Email Textfield
                MyTextField(
                  controller: fullNameTextController,
                  hintText: 'Enter Name',
                  obscureText: false,
                  prefixIcon: Icons.person,
                ),

                const SizedBox(
                  height: 10,
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

                //  Password Textfield
                MyPasswordField(
                  controller: passwordTextController,
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                LoginRegisterButton(text: 'Sign Up', onPressed: signUp),

                const SizedBox(
                  height: 20,
                ),

                // Google Button
                GoogleAuthButton(text: 'Sign Up with Google', onPressed: () {}),

                const SizedBox(height: 20),

                // Go to Register Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700)),
                    TextButton(
                        onPressed: widget.onPressed,
                        child: Text('Login now',
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
