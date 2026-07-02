// Domain models used across LinguaThread screens (UI-layer, not persistence).

class LtThread {
  const LtThread({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.cefrLevel,
    required this.language,
    required this.creatorName,
    required this.creatorGemma,
    required this.enrolledCount,
    required this.nodeCount,
    required this.durationMinutes,
    required this.tags,
    this.progressPercent,
  });

  final String id;
  final String emoji;
  final String title;
  final String description;
  final String cefrLevel;
  final String language;
  final String creatorName;
  final int creatorGemma;
  final int enrolledCount;
  final int nodeCount;
  final int durationMinutes;
  final List<String> tags;
  final double? progressPercent; // null = not enrolled
}

class LtPost {
  const LtPost({
    required this.id,
    required this.authorName,
    required this.authorGemma,
    required this.createdAt,
    required this.body,
    required this.tags,
    required this.likeCount,
    required this.commentCount,
    this.liked = false,
  });

  final String id;
  final String authorName;
  final int authorGemma;
  final String createdAt; // display string e.g. "2h"
  final String body;
  final List<String> tags;
  final int likeCount;
  final int commentCount;
  final bool liked;

  LtPost copyWith({bool? liked, int? likeCount}) {
    return LtPost(
      id: id,
      authorName: authorName,
      authorGemma: authorGemma,
      createdAt: createdAt,
      body: body,
      tags: tags,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      liked: liked ?? this.liked,
    );
  }
}

/// Feed item can be a thread or a post.
sealed class LtFeedItem {
  const LtFeedItem();
}

class LtFeedThread extends LtFeedItem {
  const LtFeedThread(this.thread);
  final LtThread thread;
}

class LtFeedPost extends LtFeedItem {
  const LtFeedPost(this.post);
  final LtPost post;
}
