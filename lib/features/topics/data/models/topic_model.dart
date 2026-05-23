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
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
        id: json['id'] as String,
        teacherId: json['teacherId'] as String,
        type: json['type'] as String? ?? 'LESSON',
        visibility: json['visibility'] as String? ?? 'PUBLIC',
        title: json['title'] as String? ?? '',
        content: json['content'] as String?,
        mediaUrl: json['mediaUrl'] as String?,
        likeCount: json['likeCount'] as int? ?? 0,
        commentCount: json['commentCount'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
