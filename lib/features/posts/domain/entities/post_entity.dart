import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String userId;
  final String content;
  final List<String> mediaUrls;
  final String? roadmapId;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final String? authorName;
  final String? authorAvatarUrl;

  const PostEntity({
    required this.id,
    required this.userId,
    required this.content,
    this.mediaUrls = const [],
    this.roadmapId,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    this.authorName,
    this.authorAvatarUrl,
  });

  @override
  List<Object?> get props => [id, userId, likeCount, commentCount, createdAt];
}
