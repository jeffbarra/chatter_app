import 'package:chatter/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordFooter extends StatelessWidget {
  const ForgotPasswordFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Get.to(const ResetPassword(),
              transition: Transition.noTransition,
              duration: const Duration(milliseconds: 100));
        },

        // Forgot Password?
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
