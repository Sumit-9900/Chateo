import 'package:chateo_app/core/theme/app_colors.dart';
import 'package:chateo_app/features/contacts/model/contact_model.dart';
import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback? onTap;

  const ContactItem({
    super.key,
    required this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.8),
        child: contact.avatar != null
            ? null // We would handle avatar image here if implemented
            : Text(
                contact.displayName.isNotEmpty
                    ? contact.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white),
              ),
      ),
      title: Text(
        contact.displayName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        contact.phoneNumber ?? 'No phone number',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      onTap: onTap,
    );
  }
}