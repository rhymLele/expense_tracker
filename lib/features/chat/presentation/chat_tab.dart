import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/presentation/shared/auth_cubit.dart';
import '../../auth/presentation/shared/auth_state.dart';
import '../../chat/data/datasources/chat_remote_datasource.dart';
import '../../chat/domain/entities/conversation_entity.dart';
import '../../chat/presentation/bloc/chat_list/chat_list_cubit.dart';
import '../../chat/presentation/pages/chat_room_page.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final userId = auth is AuthAuthenticated ? auth.user.id : '';

    return BlocProvider(
      create: (_) => ChatListCubit(
        datasource: sl<ChatRemoteDataSource>(),
        currentUserId: userId,
      )..load(),
      child: _ChatTabContent(currentUserId: userId),
    );
  }
}

class _ChatTabContent extends StatelessWidget {
  final String currentUserId;
  const _ChatTabContent({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.bgPage,
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context.read<ChatListCubit>().refresh();
              await context
                  .read<ChatListCubit>()
                  .stream
                  .firstWhere((s) => s.status != ChatListStatus.loading);
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.paddingLg,
                      AppSizes.paddingXl,
                      AppSizes.paddingLg,
                      AppSizes.paddingMd,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Tin nhắn',
                              style: AppTextStyles.headlineLarge),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.textSecondary),
                          onPressed: () {},
                          tooltip: 'Tin nhắn mới',
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.status == ChatListStatus.loading &&
                    state.conversations.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2),
                    ),
                  )
                else if (state.status == ChatListStatus.failure &&
                    state.conversations.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_outlined,
                              size: 48, color: AppColors.textHint),
                          const SizedBox(height: AppSizes.paddingMd),
                          Text(state.error ?? 'Không tải được',
                              style: AppTextStyles.bodySmall),
                          TextButton(
                            onPressed: () => context
                                .read<ChatListCubit>()
                                .refresh(),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state.conversations.isEmpty)
                  const SliverFillRemaining(
                      child: Center(child: _EmptyChat()))
                else
                  SliverList.separated(
                    itemCount: state.conversations.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 72,
                      color: AppColors.stroke,
                    ),
                    itemBuilder: (ctx, i) => _ConversationRow(
                      conv: state.conversations[i],
                      currentUserId: currentUserId,
                    ),
                  ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xxxl)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConversationRow extends StatelessWidget {
  final ConversationEntity conv;
  final String currentUserId;
  const _ConversationRow(
      {required this.conv, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final initials = conv.displayName.isNotEmpty
        ? conv.displayName[0].toUpperCase()
        : '?';

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatRoomPage(
            conversation: conv,
            currentUserId: currentUserId,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLg,
          vertical: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary50,
              backgroundImage: conv.otherUserAvatar != null
                  ? NetworkImage(conv.otherUserAvatar!)
                  : null,
              child: conv.otherUserAvatar == null
                  ? Text(initials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary600,
                      ))
                  : null,
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conv.displayName,
                          style: AppTextStyles.labelMedium
                              .copyWith(color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (conv.lastMessageAt != null)
                        Text(
                          _timeLabel(conv.lastMessageAt!),
                          style: const TextStyle(
                              fontSize: 11.5, color: AppColors.textHint),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    conv.lastMessage ?? 'Bắt đầu cuộc trò chuyện',
                    style: const TextStyle(
                        fontSize: 13.5, color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    return '${dt.day}/${dt.month}';
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
                color: AppColors.primary50, shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_outline,
                size: 40, color: AppColors.primary600),
          ),
          const SizedBox(height: AppSizes.paddingLg),
          const Text('Chưa có tin nhắn nào',
              style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            'Bắt đầu trò chuyện từ trang hồ sơ\ncủa người bạn muốn nhắn tin.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
