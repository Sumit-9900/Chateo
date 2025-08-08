import 'package:chateo_app/core/utils/normalize_phone_number.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:chateo_app/core/widgets/search_field.dart';
import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:chateo_app/features/chats/view/widgets/chat_tile.dart';
import 'package:chateo_app/features/chats/viewmodel/cubit/chats_cubit.dart';
import 'package:chateo_app/features/contacts/view/widgets/contacts_empty_widget.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_cubit.dart';
import 'package:chateo_app/features/contacts/viewmodel/contacts_state.dart';
import 'package:chateo_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final phoneNumber = getIt<AuthLocalRepository>().getPhoneNumber();
    final userId = normalizePhoneNumber(phoneNumber);
    context.read<ChatsCubit>().getChatConversations(userId: userId);
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state is ChatsFailure) {
          showSnackBar(context, message: state.message, color: Colors.red);
        }
      },
      child: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsInitial) {
            // Request permission when the page is first loaded
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ContactsCubit>().requestContactsPermission();
            });
            return const ContactsEmptyWidget(
              message: 'Initializing contacts...',
            );
          } else if (state is ContactsLoading) {
            return const Loader();
          } else if (state is ContactsPermissionRequested) {
            if (state.granted) {
              // If permission granted, load contacts
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<ContactsCubit>().loadContacts();
              });
              return const Loader();
            } else {
              // If permission denied, show message with retry button
              return ContactsEmptyWidget(
                message:
                    state.message ?? 'Permission to access contacts was denied',
                onActionPressed: () {
                  context.read<ContactsCubit>().requestContactsPermission();
                },
                actionLabel: 'Grant Permission',
              );
            }
          }

          return GestureDetector(
            onTap: () => searchFocusNode.unfocus(),
            child: Scaffold(
              appBar: AppBar(title: Text('Chats')),
              body: Column(
                children: [
                  SearchField(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      interactive: true,
                      thickness: 12,
                      radius: const Radius.circular(12),
                      child: BlocBuilder<ChatsCubit, ChatsState>(
                        builder: (context, state) {
                          if (state is ChatsLoading) {
                            return const Loader();
                          } else if (state is ChatsConversationsLoaded) {
                            final chatConversations = state.chatConversations;
                            return ListView.builder(
                              primary: true,
                              itemCount: chatConversations.length,
                              itemBuilder: (context, index) {
                                final chat = chatConversations[index];
                                return ChatTile(chatConversation: chat);
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
