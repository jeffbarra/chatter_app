import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String text;

  DrawerListTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.deepPurple.shade100),
          title: Text(
            text,
            style: TextStyle(color: Colors.deepPurple.shade100, fontSize: 16),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.deepPurple.shade100),
        ),
      ),
    );
  }
}
