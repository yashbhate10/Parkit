import 'package:flutter/material.dart';

class SearchBar1 extends StatelessWidget {
  final Function(String) onSearch;

  const SearchBar1({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: onSearch,
        decoration: const InputDecoration(
          hintText: 'Search for parking spots...',
          hintStyle: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.yellow,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        style: const TextStyle(
          color: Color(0xFF1A1D1E),
          fontSize: 14,
        ),
      ),
    );
  }
}
