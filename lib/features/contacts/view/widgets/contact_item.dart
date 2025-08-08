import 'package:chateo_app/core/router/route_constants.dart';
import 'package:chateo_app/core/theme/app_colors.dart';
import 'package:chateo_app/core/utils/send_invite_sms.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/features/contacts/model/chat_contact_model.dart';
import 'package:chateo_app/features/contacts/model/invite_contact_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactItem extends StatelessWidget {
  final ChatContactModel? matchedContact;
  final InviteContactModel? inviteContact;
  final bool isMatched;

  const ContactItem({
    super.key,
    this.matchedContact,
    this.inviteContact,
    this.isMatched = false,
  });

  @override
  Widget build(BuildContext context) {
    final dynamic contact = isMatched ? matchedContact : inviteContact;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.8),
        child: Text(
          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        contact.phoneNumber ?? 'No phone number',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      // onTap: onTap,
      trailing: isMatched
          ? IconButton(
              onPressed: () {
                context.pushNamed(RouteConstants.chat, extra: matchedContact);
              },
              icon: const Icon(Icons.send),
            )
          : TextButton(
              onPressed: () async {
                try {
                  sendInviteSms(
                    phoneNumber: contact.phoneNumber!,
                    message: 'Hey! Join me on Chateo – the best way to chat!',
                  );
                } catch (e) {
                  showSnackBar(
                    context,
                    message: e.toString(),
                    color: Colors.red,
                  );
                }
              },
              child: Text('Invite', style: TextStyle(color: AppColors.primary)),
            ),
    );
  }
}
