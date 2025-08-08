import 'package:chateo_app/features/chats/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatConversationModel extends Equatable {
  final List<String> members;
  final MessageModel lastMessage;
  final Timestamp updatedAt;

  const ChatConversationModel({
    required this.members,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      members: List<String>.from(json['members']),
      lastMessage: MessageModel.fromJson(json['lastMessage']),
      updatedAt: json['updatedAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'members': members,
      'lastMessage': lastMessage.toJson(),
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [members, lastMessage, updatedAt];
}