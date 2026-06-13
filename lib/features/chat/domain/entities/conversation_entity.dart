import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String type; // direct | group
  final String? name; // group only
  final String? otherUserId;
  final String? otherUserName;
  final String? otherUserAvatar;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime createdAt;

  const ConversationEntity({
    required this.id,
    required this.type,
    this.name,
    this.otherUserId,
    this.otherUserName,
    this.otherUserAvatar,
    this.lastMessage,
    this.lastMessageAt,
    required this.createdAt,
  });

  bool get isDirect => type == 'direct';

  String get displayName => isDirect ? (otherUserName ?? 'Người dùng') : (name ?? 'Nhóm');

  @override
  List<Object?> get props => [id, type, lastMessage, lastMessageAt];
}
