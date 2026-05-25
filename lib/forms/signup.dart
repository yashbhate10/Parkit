import 'package:flutter/material.dart';
import 'package:project_ui_demo/forms/login.dart';
import 'package:project_ui_demo/services/login_signup_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  AuthService _authService = new AuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage("All fields are required!");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("Passwords do not match!");
      return;
    }

    try {
      await _authService.signUpWithEmailAndPassword(username, email, password);
      _showMessage("Signup Successful!", isSuccess: true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
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
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildSignupForm(),
                  const SizedBox(height: 20),
                  _buildDivider(),
                  const SizedBox(height: 20),
                  _buildGoogleSignIn(),
                  const SizedBox(height: 20),
                  _buildLoginLink(),
                  const SizedBox(height: 40),
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
          "Create Account",
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
          "Sign up to get started",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
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
          _buildTextField(
              "Username", Icons.person_outline, _usernameController),
          const SizedBox(height: 16),
          _buildTextField("Email", Icons.email_outlined, _emailController),
          const SizedBox(height: 16),
          _buildTextField("Password", Icons.lock_outline, _passwordController,
              isPassword: true),
          const SizedBox(height: 16),
          _buildTextField("Confirm Password", Icons.lock_outline,
              _confirmPasswordController,
              isPassword: true),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _signUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              minimumSize: const Size(double.infinity, 50),
              elevation: 0,
            ),
            child: const Text(
              "Sign Up",
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

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.black.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withOpacity(0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Or",
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildGoogleSignIn() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          "Sign up with Google",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          },
          child: const Text("Login"),
        ),
      ],
    );
  }
}
