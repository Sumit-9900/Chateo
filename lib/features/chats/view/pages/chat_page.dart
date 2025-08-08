import 'package:chateo_app/core/utils/generate_chat_id.dart';
import 'package:chateo_app/core/utils/normalize_phone_number.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/input_field.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:chateo_app/features/chats/models/message_model.dart';
import 'package:chateo_app/features/chats/viewmodel/cubit/chats_cubit.dart';
import 'package:chateo_app/features/contacts/model/chat_contact_model.dart';
import 'package:chateo_app/init_dependencies.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  final ChatContactModel chatContact;
  const ChatPage({super.key, required this.chatContact});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final senderPhoneNumber = getIt<AuthLocalRepository>().getPhoneNumber();
    final chatId = generateChatId(
      normalizePhoneNumber(widget.chatContact.phoneNumber),
      normalizePhoneNumber(senderPhoneNumber),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatsCubit>().getMessages(chatId: chatId);
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = getIt<AuthLocalRepository>().getPhoneNumber();

    return BlocListener<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsFailure) {
          showSnackBar(context, message: state.message, color: Colors.red);
        } else if (state is ChatsSuccess) {
          messageController.clear();
        } else if (state is ChatsLoaded) {
          messageFocusNode.requestFocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.chatContact.name)),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatsCubit, ChatsState>(
                  builder: (context, state) {
                    if (state is ChatsLoading) {
                      return const Loader();
                    } else if (state is ChatsInitial) {
                      return const Loader();
                    } else if (state is ChatsLoaded) {
                      final messages = state.messages;

                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return Text(message.message);
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: InputField(
                        hintText: 'Type a message',
                        controller: messageController,
                        focusNode: messageFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Message cannot be empty!!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<ChatsCubit>().sendMessage(
                              message: MessageModel(
                                senderId: normalizePhoneNumber(phoneNumber),
                                receiverId: normalizePhoneNumber(
                                  widget.chatContact.phoneNumber,
                                ),
                                message: messageController.text.trim(),
                                createdAt: Timestamp.now(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
