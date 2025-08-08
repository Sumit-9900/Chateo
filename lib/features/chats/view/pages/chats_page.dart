import 'package:chateo_app/core/utils/normalize_phone_number.dart';
import 'package:chateo_app/core/utils/show_snackbar.dart';
import 'package:chateo_app/core/widgets/loader.dart';
import 'package:chateo_app/core/widgets/search_field.dart';
import 'package:chateo_app/features/auth/repository/auth_local_repository.dart';
import 'package:chateo_app/features/chats/viewmodel/cubit/chats_cubit.dart';
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
      child: GestureDetector(
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
                            return ListTile(
                              title: Text(chat.lastMessage.message),
                              subtitle: Text(
                                chat.updatedAt.toDate().toString(),
                              ),
                            );
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
      ),
    );
  }
}
