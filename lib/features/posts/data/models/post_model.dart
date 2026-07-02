import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.userId,
    required super.content,
    super.mediaUrls,
    super.roadmapId,
    required super.likeCount,
    required super.commentCount,
    required super.createdAt,
    super.authorName,
    super.authorAvatarUrl,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final mediaRaw = json['mediaUrls'];
    final mediaUrls = mediaRaw is List
        ? mediaRaw.cast<String>()
        : <String>[];

    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      mediaUrls: mediaUrls,
      roadmapId: json['roadmapId'] as String?,
      likeCount: (json['likeCount'] as int?) ?? 0,
      commentCount: (json['commentCount'] as int?) ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      authorName: user?['name'] as String? ??
          user?['username'] as String? ??
          user?['email'] as String?,
      authorAvatarUrl: user?['avatarUrl'] as String?,
    );
  }
}
