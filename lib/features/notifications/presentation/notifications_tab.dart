import 'package:flutter/material.dart';
import '../../../core/base/base_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lingua_thread/theme/lt_colors.dart';
import '../../../lingua_thread/theme/lt_typography.dart';
import '../../../lingua_thread/widgets/lt_avatar.dart';
import '../../notifications/domain/entities/notification_entity.dart';
import '../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../notifications/presentation/bloc/notifications_state.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();
        return Scaffold(
          backgroundColor: LtColors.bg,
          appBar: AppBar(
            backgroundColor: LtColors.bg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              state.unreadCount > 0
                  ? 'Thông báo (${state.unreadCount})'
                  : 'Thông báo',
              style: LtTypography.pageTitle,
            ),
            actions: [
              if (state.unreadCount > 0)
                TextButton(
                  onPressed: cubit.markAllRead,
                  child: Text(
                    'Đọc tất cả',
                    style: LtTypography.smallMed
                        .copyWith(color: LtColors.textMuted),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, state, cubit),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state,
      NotificationsCubit cubit) {
    if (state.status.isLoading &&
        state.notifications.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: LtColors.ink));
    }
    if (state.status.isFailure &&
        state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Không tải được thông báo', style: LtTypography.body),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: cubit.refresh,
              child: Text('Thử lại',
                  style:
                      LtTypography.smallBold.copyWith(color: LtColors.ink)),
            ),
          ],
        ),
      );
    }
    if (state.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔔', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('Chưa có thông báo nào', style: LtTypography.body),
            const SizedBox(height: 4),
            Text('Khi có hoạt động mới, bạn sẽ thấy ở đây',
                style: LtTypography.small),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cubit.refresh,
      color: LtColors.ink,
      child: ListView.builder(
        itemCount: state.notifications.length,
        itemBuilder: (ctx, i) {
          final notif = state.notifications[i];
          return _NotifItem(
            notif: notif,
            onTap: () => cubit.markRead(notif.id),
          );
        },
      ),
    );
  }
}

// ─── Notification item ────────────────────────────────────────────────────────

class _NotifItem extends StatelessWidget {
  const _NotifItem({required this.notif, required this.onTap});

  final NotificationEntity notif;
  final VoidCallback onTap;

  static const _typeIcon = {
    'post_liked': '♥',
    'post_commented': '💬',
    'user_followed': '👤',
    'roadmap_completed': '⬡',
    'daily_reminder': '🔥',
    'submission_graded': '📝',
    'achievement_unlocked': '🏆',
  };

  @override
  Widget build(BuildContext context) {
    final icon = _typeIcon[notif.type] ?? '🔔';
    final isUnread = notif.isUnread;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: isUnread ? LtColors.bgFafafa : LtColors.bg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar or icon badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                notif.actorName.isNotEmpty
                    ? LtAvatar(name: notif.actorName, size: 36)
                    : Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: LtColors.bgMuted,
                          shape: BoxShape.circle,
                          border: Border.all(color: LtColors.divider),
                        ),
                        alignment: Alignment.center,
                        child: Text(icon,
                            style: const TextStyle(fontSize: 16)),
                      ),
                if (notif.actorName.isNotEmpty)
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: LtColors.bgMuted,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Text(icon,
                          style: const TextStyle(fontSize: 9)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.displayText,
                    style: LtTypography.body.copyWith(
                      fontWeight:
                          isUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatAge(notif.createdAt),
                    style: LtTypography.caption,
                  ),
                ],
              ),
            ),
            // Unread dot
            if (isUnread)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 8),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: LtColors.ink,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _formatAge(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m trước';
    if (d.inHours < 24) return '${d.inHours}h trước';
    if (d.inDays < 30) return '${d.inDays}d trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
