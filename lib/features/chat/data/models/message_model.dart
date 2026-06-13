import 'dart:developer' as dev;
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    super.senderName,
    super.senderAvatar,
    required super.messageText,
    super.taggedRoadmapId,
    super.taggedRoadmapTitle,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    try {
      final sender = json['sender'] as Map<String, dynamic>?;
      final roadmap = json['taggedRoadmap'] as Map<String, dynamic>?;
      return MessageModel(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        senderId: json['senderId'] as String,
        senderName: sender?['name'] as String? ?? sender?['username'] as String?,
        senderAvatar: sender?['avatarUrl'] as String?,
        messageText: json['messageText'] as String? ?? '',
        taggedRoadmapId: json['taggedRoadmapId'] as String?,
        taggedRoadmapTitle: roadmap?['title'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } catch (e, st) {
      dev.log('MessageModel.fromJson error: $e', stackTrace: st, name: 'Chat');
      rethrow;
    }
  }
}
