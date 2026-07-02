import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({int page, int limit});
  Future<int> getUnreadCount();
  Future<void> markRead(String id);
  Future<void> markAllRead();
}

class NotificationsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements NotificationsRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications(
      {int page = 1, int limit = 20}) async {
    final res = await baseSendRequest(
      ApiConstants.notifications,
      HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
    );
    final raw = res['data'];
    final List dataList =
        raw is List ? raw : ((raw as Map<String, dynamic>?)?['items'] ?? (raw)?['data'] ?? []) as List;
    return dataList
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final res = await baseSendRequest(
        ApiConstants.notificationsUnreadCount, HttpMethod.get);
    final data = res['data'];
    if (data is Map) return (data['count'] as int?) ?? 0;
    return (data as int?) ?? 0;
  }

  @override
  Future<void> markRead(String id) =>
      baseSendRequest(ApiConstants.notificationRead(id), HttpMethod.patch);

  @override
  Future<void> markAllRead() =>
      baseSendRequest(ApiConstants.notificationsReadAll, HttpMethod.patch);
}
