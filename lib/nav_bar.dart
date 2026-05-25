import 'package:flutter/material.dart';
import 'package:project_ui_demo/map_config_page.dart';
import 'package:project_ui_demo/my_bookings.dart';
import 'home_page.dart';
import 'package:project_ui_demo/profile_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    MyBookingsPage(),
    MapConfigPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkIT', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.location_city), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.yellow.shade700,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

