import 'package:chatter/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.deepPurple,
            onPrimary: Colors.white, // Text on primary color
            background: Colors.white,
            onSecondary: Colors.white,
            error: Colors.red,
            onBackground: Colors.white,
            onError: Colors.deepPurple,
            onSurface: Colors.black, // colors for text fields
            secondary: Colors.white,
            surface: Colors.grey.shade200,

            // colors for widgets
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: Colors.deepPurple,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Chatter',
        home: const AuthPage());
  }
}
