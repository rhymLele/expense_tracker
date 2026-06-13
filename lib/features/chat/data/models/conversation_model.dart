import 'dart:developer' as dev;
import '../../domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.type,
    super.name,
    super.otherUserId,
    super.otherUserName,
    super.otherUserAvatar,
    super.lastMessage,
    super.lastMessageAt,
    required super.createdAt,
  });

  factory ConversationModel.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    try {
      final type = json['type'] as String? ?? 'direct';
      String? otherUserId, otherUserName, otherUserAvatar;

      if (type == 'direct') {
        final userA = json['userA'] as Map<String, dynamic>?;
        final userB = json['userB'] as Map<String, dynamic>?;
        final userAId = json['userAId'] as String?;
        final userBId = json['userBId'] as String?;

        if (userAId == currentUserId) {
          otherUserId = userBId;
          otherUserName = _name(userB);
          otherUserAvatar = userB?['avatarUrl'] as String?;
        } else {
          otherUserId = userAId;
          otherUserName = _name(userA);
          otherUserAvatar = userA?['avatarUrl'] as String?;
        }
      }

      return ConversationModel(
        id: json['id'] as String,
        type: type,
        name: json['name'] as String?,
        otherUserId: otherUserId,
        otherUserName: otherUserName,
        otherUserAvatar: otherUserAvatar,
        lastMessage: json['lastMessage'] as String?,
        lastMessageAt: json['lastMessageAt'] != null
            ? DateTime.tryParse(json['lastMessageAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } catch (e, st) {
      dev.log('ConversationModel.fromJson error: $e', stackTrace: st, name: 'Chat');
      return ConversationModel(
        id: json['id'] as String? ?? '',
        type: 'direct',
        createdAt: DateTime.now(),
      );
    }
  }

  static String? _name(Map<String, dynamic>? user) =>
      user?['name'] as String? ?? user?['username'] as String? ?? user?['email'] as String?;
}
