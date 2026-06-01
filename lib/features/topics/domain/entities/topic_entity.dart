import 'package:equatable/equatable.dart';

class TopicEntity extends Equatable {
  final String id;
  final String teacherId;
  final String type;
  final String visibility;
  final String title;
  final String? content;
  final String? mediaUrl;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  // Author display info — populated from nested teacher/author object
  final String? authorName;
  final String? authorAvatarUrl;

  const TopicEntity({
    required this.id,
    required this.teacherId,
    required this.type,
    required this.visibility,
    required this.title,
    this.content,
    this.mediaUrl,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    this.authorName,
    this.authorAvatarUrl,
  });

  @override
  List<Object?> get props => [
        id, teacherId, type, visibility, title,
        likeCount, commentCount, createdAt,
      ];
}
