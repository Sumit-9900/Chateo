import 'package:chateo_app/core/constants/app_constants.dart';
import 'package:chateo_app/core/failure/app_failure.dart';
import 'package:chateo_app/core/utils/generate_chat_id.dart';
import 'package:chateo_app/features/chats/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chateo_app/features/chats/models/chat_conversation_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class ChatsRemoteRepository {
  Future<Either<AppFailure, void>> sendMessage({required MessageModel message});
  Stream<Either<AppFailure, List<MessageModel>>> getAllMessages({
    required String chatId,
  });
  Stream<Either<AppFailure, List<ChatConversationModel>>>
  getAllChatConversations({required String userId});
}

class ChatsRemoteRepositoryImpl implements ChatsRemoteRepository {
  final FirebaseFirestore firestore;
  ChatsRemoteRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, void>> sendMessage({
    required MessageModel message,
  }) async {
    try {
      final chatId = generateChatId(message.senderId, message.receiverId);
      final messageRef = firestore
          .collection(AppConstants.chatsKey)
          .doc(chatId)
          .collection(AppConstants.messageKey)
          .doc(); // auto ID

      final chatDocRef = firestore
          .collection(AppConstants.chatsKey)
          .doc(chatId);

      final messageJson = message.toJson();

      final batch = firestore.batch();

      // Write message
      batch.set(messageRef, messageJson);

      // Update last message preview
      batch.set(chatDocRef, {
        'members': [message.senderId, message.receiverId],
        'lastMessage': messageJson,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      return right(null);
    } catch (e) {
      return left(AppFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<AppFailure, List<MessageModel>>> getAllMessages({
    required String chatId,
  }) async* {
    try {
      final snapshots = firestore
          .collection(AppConstants.chatsKey)
          .doc(chatId)
          .collection(AppConstants.messageKey)
          .orderBy('createdAt', descending: true)
          .snapshots();

      await for (final snapshot in snapshots) {
        final messages = snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();

        yield right(messages);
      }
    } catch (e) {
      yield left(AppFailure(message: e.toString()));
    }
  }

  @override
  Stream<Either<AppFailure, List<ChatConversationModel>>>
  getAllChatConversations({required String userId}) async* {
    try {
      final snapshots = firestore
          .collection(AppConstants.chatsKey)
          .where('members', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots();

      await for (final snapshot in snapshots) {
        final chatConversations = snapshot.docs
            .map((doc) => ChatConversationModel.fromJson(doc.data()))
            .toList();

        yield right(chatConversations);
      }
    } catch (e) {
      yield left(AppFailure(message: e.toString()));
    }
  }
}
