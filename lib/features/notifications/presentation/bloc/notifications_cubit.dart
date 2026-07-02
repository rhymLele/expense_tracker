import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../data/datasources/notifications_remote_datasource.dart';
import 'notifications_state.dart';

class NotificationsCubit extends LoadCubit<NotificationsState> {
  final NotificationsRemoteDataSource _ds;
  static const _limit = 20;

  NotificationsCubit({required NotificationsRemoteDataSource datasource})
      : _ds = datasource,
        super(const NotificationsState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    if (state.status.isLoading) return;
    await guard(() async {
      final items = await _ds.getNotifications(page: 1, limit: _limit);
      final count = await _ds.getUnreadCount();
      return state.copyWith(
        status: ViewStatus.success,
        notifications: items,
        unreadCount: count,
        hasMore: items.length >= _limit,
        page: 1,
      );
    });
  }

  Future<void> refresh() => load();

  Future<void> loadMore() async {
    if (state.status.isLoadingMore || !state.hasMore) return;
    await guard(
      loading: ViewStatus.loadingMore,
      () async {
        final nextPage = state.page + 1;
        final items = await _ds.getNotifications(page: nextPage, limit: _limit);
        return state.copyWith(
          status: ViewStatus.success,
          notifications: [...state.notifications, ...items],
          hasMore: items.length >= _limit,
          page: nextPage,
        );
      },
    );
  }

  Future<void> markRead(String id) async {
    try {
      await _ds.markRead(id);
      final updated = state.notifications
          .map((n) => n.id == id ? n.copyWithReadAt(DateTime.now()) : n)
          .toList();
      emit(state.copyWith(
        notifications: updated,
        unreadCount: (state.unreadCount - 1).clamp(0, 9999),
      ));
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await _ds.markAllRead();
      final updated = state.notifications
          .map((n) => n.isUnread ? n.copyWithReadAt(DateTime.now()) : n)
          .toList();
      emit(state.copyWith(notifications: updated, unreadCount: 0));
    } catch (_) {}
  }
}
