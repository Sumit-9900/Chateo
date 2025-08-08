part of 'chats_cubit.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class ChatsSuccess extends ChatsState {}

final class ChatsLoaded extends ChatsState {
  final List<MessageModel> messages;
  const ChatsLoaded(this.messages);
}

final class ChatsConversationsLoaded extends ChatsState {
  final List<ChatConversationModel> chatConversations;
  const ChatsConversationsLoaded(this.chatConversations);

  @override
  List<Object> get props => [chatConversations];
}

final class ChatsFailure extends ChatsState {
  final String message;
  const ChatsFailure(this.message);

  @override
  List<Object> get props => [message];
}
