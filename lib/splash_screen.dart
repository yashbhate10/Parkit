import 'package:flutter/material.dart';
import 'package:project_ui_demo/forms/login.dart';
import 'package:project_ui_demo/home_page.dart';
import 'package:project_ui_demo/nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/entry_logo.png',
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/park_it_text.png'),
            const SizedBox(height: 10),
            Text(
              'Smart Parking Application',
              style: GoogleFonts.roboto(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w300, // Thin text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
