import 'package:flutter/material.dart';

class ContactsEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const ContactsEmptyWidget({
    super.key,
    required this.message,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contacts_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onActionPressed != null && actionLabel != null) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onActionPressed,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
