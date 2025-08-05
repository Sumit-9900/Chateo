import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
