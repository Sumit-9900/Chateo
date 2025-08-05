import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String)? onChanged;
  const SearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
