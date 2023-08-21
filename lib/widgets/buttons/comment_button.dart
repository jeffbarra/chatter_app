import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final Function()? onTap;
  const CommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.comment_outlined, color: Colors.grey),
    );
  }
}
