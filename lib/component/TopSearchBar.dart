import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const TopSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Search for clients...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
