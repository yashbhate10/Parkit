import 'package:flutter/material.dart';

class MyBookingsPage extends StatelessWidget {
  final List<String> bookings = [];

  MyBookingsPage({super.key}); // Currently empty, meaning no bookings available

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: bookings.isEmpty
            ? const Text(
          'No bookings available',
          style: TextStyle(fontSize: 18),
        )
            : ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bookings[index]),
            );
          },
        ),
      ),
    );
  }
}
