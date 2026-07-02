import '../../domain/entities/topic_comment_entity.dart';

class TopicCommentModel extends TopicCommentEntity {
  const TopicCommentModel({
    required super.id,
    required super.topicId,
    required super.userId,
    super.parentId,
    required super.content,
    required super.createdAt,
    super.authorName,
  });

  factory TopicCommentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final authorName = user?['displayName'] as String? ??
        user?['name'] as String? ??
        user?['userName'] as String?;
    return TopicCommentModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      userId: json['userId'] as String,
      parentId: json['parentId'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: authorName,
    );
  }
}
