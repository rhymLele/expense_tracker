import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.payload,
    this.readAt,
    required this.createdAt,
  });

  bool get isUnread => readAt == null;

  String get actorName =>
      (payload['actorName'] as String?) ?? '';

  String? get actorAvatarUrl =>
      payload['actorAvatarUrl'] as String?;

  String get preview =>
      (payload['preview'] as String?) ?? '';

  String get displayText {
    return switch (type) {
      'post_liked'     => '$actorName đã thích bài đăng của bạn',
      'post_commented' => '$actorName đã bình luận: $preview',
      'user_followed'  => '$actorName đã bắt đầu theo dõi bạn',
      'roadmap_completed' => 'Bạn đã hoàn thành lộ trình "$preview"!',
      'daily_reminder' => preview.isNotEmpty ? preview : 'Hãy tiếp tục học hôm nay 🔥',
      'submission_graded' => 'Bài nộp của bạn đã được chấm điểm',
      'achievement_unlocked' => 'Bạn đã mở khoá thành tích "$preview"!',
      _ => preview,
    };
  }

  NotificationEntity copyWithReadAt(DateTime readAt) => NotificationEntity(
        id: id,
        type: type,
        payload: payload,
        readAt: readAt,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, type, readAt, createdAt];
}
