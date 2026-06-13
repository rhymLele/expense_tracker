import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String messageText;
  final String? taggedRoadmapId;
  final String? taggedRoadmapTitle;
  final DateTime createdAt;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.messageText,
    this.taggedRoadmapId,
    this.taggedRoadmapTitle,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, conversationId, senderId, messageText, createdAt];
}
