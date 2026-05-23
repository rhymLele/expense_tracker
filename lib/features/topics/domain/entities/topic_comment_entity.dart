import 'package:equatable/equatable.dart';

class TopicCommentEntity extends Equatable {
  final String id;
  final String topicId;
  final String userId;
  final String? parentId;
  final String content;
  final DateTime createdAt;

  const TopicCommentEntity({
    required this.id,
    required this.topicId,
    required this.userId,
    this.parentId,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, topicId, userId, parentId, content, createdAt];
}
