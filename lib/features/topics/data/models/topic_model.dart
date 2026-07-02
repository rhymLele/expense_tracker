import '../../domain/entities/topic_entity.dart';

class TopicModel extends TopicEntity {
  const TopicModel({
    required super.id,
    required super.teacherId,
    required super.type,
    required super.visibility,
    required super.title,
    super.content,
    super.mediaUrl,
    required super.likeCount,
    required super.commentCount,
    required super.createdAt,
    super.authorName,
    super.authorAvatarUrl,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    // Author info may come from nested teacher/author/user object
    final author = json['teacher'] as Map<String, dynamic>? ??
        json['author'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>?;
    final authorName = author?['displayName'] as String? ??
        author?['name'] as String? ??
        author?['userName'] as String?;
    final authorAvatarUrl = author?['avatarUrl'] as String? ??
        author?['avatar'] as String?;

    return TopicModel(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      type: json['type'] as String? ?? 'LESSON',
      visibility: json['visibility'] as String? ?? 'PUBLIC',
      title: json['title'] as String? ?? '',
      content: json['description'] as String? ?? json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
    );
  }
}
