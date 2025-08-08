import 'dart:async';

import 'package:chateo_app/core/utils/generate_chat_id.dart';
import 'package:chateo_app/features/chats/models/message_model.dart';
import 'package:chateo_app/features/chats/repository/chats_remote_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chateo_app/features/chats/models/chat_conversation_model.dart';
import 'package:equatable/equatable.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRemoteRepository _chatsRemoteRepository;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _chatConversationsSubscription;
  ChatsCubit({required ChatsRemoteRepository chatsRemoteRepository})
    : _chatsRemoteRepository = chatsRemoteRepository,
      super(ChatsInitial());

  Future<void> sendMessage({required MessageModel message}) async {
    final result = await _chatsRemoteRepository.sendMessage(message: message);

    result.fold((failure) => emit(ChatsFailure(failure.message)), (success) {
      final chatId = generateChatId(message.senderId, message.receiverId);
      emit(ChatsSuccess());
      return getMessages(chatId: chatId);
    });
  }

  Future<void> getMessages({required String chatId}) async {
    if (state is! ChatsLoaded) {
      emit(ChatsLoading());
    }
    _messageSubscription?.cancel();

    _messageSubscription = _chatsRemoteRepository
        .getAllMessages(chatId: chatId)
        .listen((either) {
          either.fold(
            (failure) => emit(ChatsFailure(failure.message)),
            (messages) => emit(ChatsLoaded(messages)),
          );
        });
  }

  Future<void> getChatConversations({required String userId}) async {
    emit(ChatsLoading());
    _chatConversationsSubscription?.cancel();

    _chatConversationsSubscription = _chatsRemoteRepository
        .getAllChatConversations(userId: userId)
        .listen((either) {
          either.fold(
            (failure) => emit(ChatsFailure(failure.message)),
            (chatConversations) =>
                emit(ChatsConversationsLoaded(chatConversations)),
          );
        });
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _chatConversationsSubscription?.cancel();
    return super.close();
  }
}
