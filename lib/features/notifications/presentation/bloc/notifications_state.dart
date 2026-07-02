import '../../../../core/base/base_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsState extends BaseState<NotificationsState> {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasMore;
  final int page;

  const NotificationsState({
    super.status,
    super.error,
    this.notifications = const [],
    this.unreadCount = 0,
    this.hasMore = true,
    this.page = 1,
  });

  NotificationsState copyWith({
    ViewStatus? status,
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasMore,
    int? page,
    String? error,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        unreadCount: unreadCount ?? this.unreadCount,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
      );

  @override
  NotificationsState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props =>
      [status, error, notifications, unreadCount, hasMore, page];
}
