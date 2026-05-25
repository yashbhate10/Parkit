import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_ui_demo/forms/signup.dart';
import 'package:project_ui_demo/nav_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107), // Warm yellow background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 40),
                  // Illustration
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Login Form
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  // Additional Options
                  _buildAdditionalOptions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            shadows: [
              Shadow(
                offset: const Offset(1, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Username TextField
          TextField(
            decoration: InputDecoration(
              hintText: "Username",
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
              prefixIcon: Icon(Icons.person_outline,
                  color: Colors.black.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          // Password TextField
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
              prefixIcon: Icon(Icons.lock_outline,
                  color: Colors.black.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 24),
          // Login Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NavBar()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupPage()));
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
