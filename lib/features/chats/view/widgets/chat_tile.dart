import 'package:chateo_app/core/utils/normalize_phone_number.dart';
import 'package:chateo_app/features/chats/models/chat_conversation_model.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_cubit.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTile extends StatelessWidget {
  final ChatConversationModel chatConversation;
  const ChatTile({super.key, required this.chatConversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // backgroundImage: NetworkImage(chatConversation.user.photoUrl),
      ),
      title: BlocSelector<ContactsCubit, ContactsState, String>(
        selector: (state) {
          if (state is ContactsLoaded) {
            return state.contact.matched
                .firstWhere(
                  (element) =>
                      normalizePhoneNumber(element.phoneNumber) ==
                      normalizePhoneNumber(
                        chatConversation.lastMessage.receiverId,
                      ),
                )
                .name;
          }

          return '';
        },
        builder: (context, name) {
          return Text(name);
        },
      ),
      subtitle: Text(chatConversation.lastMessage.message),
    );
  }
}
