import 'package:flutter/material.dart';

void showSnackBar(
  BuildContext context, {
  required String message,
  required Color color,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}
