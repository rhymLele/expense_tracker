import '../entities/topic_entity.dart';

/// Kết quả toggle like (optimistic) trên một danh sách topic.
class LikeToggleResult {
  final List<TopicEntity> topics;
  final Set<String> likedTopicIds;

  const LikeToggleResult({required this.topics, required this.likedTopicIds});
}

/// Nghiệp vụ like: đảo trạng thái like của [topicId] trên danh sách hiện tại —
/// cập nhật `likeCount` ±1 và tập id đã like. Thuần domain, không side-effect,
/// dùng cho cập nhật optimistic ở tầng presentation.
class ApplyLikeToggleUseCase {
  const ApplyLikeToggleUseCase();

  LikeToggleResult call({
    required String topicId,
    required List<TopicEntity> topics,
    required Set<String> likedTopicIds,
  }) {
    final wasLiked = likedTopicIds.contains(topicId);
    final delta = wasLiked ? -1 : 1;

    final nextIds = Set<String>.from(likedTopicIds);
    if (wasLiked) {
      nextIds.remove(topicId);
    } else {
      nextIds.add(topicId);
    }

    final nextTopics = topics
        .map((t) =>
            t.id == topicId ? t.copyWith(likeCount: t.likeCount + delta) : t)
        .toList();

    return LikeToggleResult(topics: nextTopics, likedTopicIds: nextIds);
  }
}
