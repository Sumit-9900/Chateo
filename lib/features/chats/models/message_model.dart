import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video');

  final String type;
  const MessageEnum(this.type);
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'video':
        return MessageEnum.video;
      default:
        return MessageEnum.text;
    }
  }
}

class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final MessageEnum messageType;
  final Timestamp createdAt;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.messageType,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      messageType: (json['messageType'] as String).toEnum(),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageType': messageType.type,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'MessageModel(senderId: $senderId, receiverId: $receiverId, message: $message, messageType: $messageType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MessageModel &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.message == message &&
        other.messageType == messageType &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return senderId.hashCode ^
        receiverId.hashCode ^
        message.hashCode ^
        messageType.hashCode ^
        createdAt.hashCode;
  }
}
