import 'package:flutter/material.dart';

class CarDetailsPage extends StatefulWidget {
  const CarDetailsPage({Key? key}) : super(key: key);

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage>
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
                  _buildHeader(),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildCarDetailsForm(),
                  const SizedBox(height: 20),
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
          "Car Details",
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
          "Enter your car information",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCarDetailsForm() {
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
          _buildTextField("Car Model", Icons.car_rental),
          const SizedBox(height: 16),
          _buildTextField("Car Registration Number", Icons.pin),
          const SizedBox(height: 16),
          _buildTextField("Car Color", Icons.color_lens),
          const SizedBox(height: 16),
          _buildTextField("Car Type", Icons.category),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement car details submission
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
              "Submit",
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

  Widget _buildTextField(String hint, IconData icon) {
    return TextField(
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

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // TODO: Implement clear form functionality
          },
          child: Text(
            "Clear Form",
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

