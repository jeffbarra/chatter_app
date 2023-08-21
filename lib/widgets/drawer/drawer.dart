import 'package:chatter/pages/home_page.dart';
import 'package:chatter/pages/profile_page.dart';
import 'package:chatter/widgets/drawer/drawer_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
// Current User
    final currentUser = FirebaseAuth.instance.currentUser!;

// Sign User Out
    void signOut() {
      FirebaseAuth.instance.signOut();
    }

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        children: [
          // Header
          DrawerHeader(
            child: Text(
              'chatter',
              style: GoogleFonts.rammettoOne(fontSize: 30, color: Colors.white),
            ),
          ),

          // Home List Tile
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Get.to(
                () => const HomePage(),
                transition: Transition.noTransition,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: DrawerListTile(
              icon: Icons.home_rounded,
              text: 'Home',
            ),
          ),

          // Profile List Tile
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Get.to(
                () => const ProfilePage(),
                transition: Transition.noTransition,
                duration: Duration(milliseconds: 300),
              );
            },
            child: DrawerListTile(
              icon: Icons.person,
              text: 'Profile',
            ),
          ),

          // Logout List Tile
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              signOut();
            },
            child: DrawerListTile(
              icon: Icons.logout_rounded,
              text: 'Logout',
            ),
          ),
        ],
      ),
    );
  }
}
