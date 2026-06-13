import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/chat_room/chat_room_cubit.dart';

class ChatRoomPage extends StatelessWidget {
  final ConversationEntity conversation;
  final String currentUserId;

  const ChatRoomPage({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatRoomCubit(datasource: sl<ChatRemoteDataSource>())
        ..loadRoom(conversation.id),
      child: _ChatRoomView(
        conversation: conversation,
        currentUserId: currentUserId,
      ),
    );
  }
}

class _ChatRoomView extends StatefulWidget {
  final ConversationEntity conversation;
  final String currentUserId;

  const _ChatRoomView({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  State<_ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<_ChatRoomView> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary50,
              child: Text(
                widget.conversation.displayName.isNotEmpty
                    ? widget.conversation.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary600,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(
              child: Text(
                widget.conversation.displayName,
                style: AppTextStyles.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
              listener: (_, state) {
                if (state.status == ChatRoomStatus.success) _scrollToBottom();
              },
              builder: (context, state) {
                if (state.status == ChatRoomStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary, strokeWidth: 2),
                  );
                }
                if (state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Bắt đầu cuộc trò chuyện 👋',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textMuted),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                    vertical: AppSizes.paddingMd,
                  ),
                  itemCount: state.messages.length,
                  itemBuilder: (_, i) {
                    final msg = state.messages[i];
                    final isMine = msg.senderId == widget.currentUserId;
                    final showAvatar = !isMine &&
                        (i == 0 ||
                            state.messages[i - 1].senderId !=
                                msg.senderId);
                    return _MessageBubble(
                      message: msg,
                      isMine: isMine,
                      showAvatar: showAvatar,
                    );
                  },
                );
              },
            ),
          ),
          _InputBar(
            controller: _ctrl,
            onSend: () {
              final text = _ctrl.text.trim();
              if (text.isEmpty) return;
              context.read<ChatRoomCubit>().sendMessage(text);
              _ctrl.clear();
            },
          ),
        ],
      ),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMine;
  final bool showAvatar;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            if (showAvatar)
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary50,
                child: Text(
                  (message.senderName?.isNotEmpty == true)
                      ? message.senderName![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary600,
                  ),
                ),
              )
            else
              const SizedBox(width: 28),
            const SizedBox(width: AppSizes.paddingXs),
          ],
          // Roadmap tag card
          if (message.taggedRoadmapId != null)
            _RoadmapTag(title: message.taggedRoadmapTitle ?? 'Lộ trình')
          else
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMine
                      ? AppColors.primary
                      : AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMine ? 16 : 4),
                    bottomRight: Radius.circular(isMine ? 4 : 16),
                  ),
                  border: isMine
                      ? null
                      : Border.all(color: AppColors.stroke),
                ),
                child: Column(
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.messageText,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: isMine
                            ? AppColors.background
                            : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _timeLabel(message.createdAt),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isMine
                            ? AppColors.background.withValues(alpha: 0.7)
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _timeLabel(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _RoadmapTag extends StatelessWidget {
  final String title;
  const _RoadmapTag({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.all(AppSizes.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.route_outlined,
              size: 18, color: AppColors.primary600),
          const SizedBox(width: AppSizes.paddingXs),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Input Bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        final sending = state.status == ChatRoomStatus.sending;
        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSizes.paddingMd,
            AppSizes.paddingXs,
            AppSizes.paddingMd,
            AppSizes.paddingMd + MediaQuery.viewPaddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.stroke)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    hintStyle: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textHint),
                    filled: true,
                    fillColor: AppColors.bgMuted,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingMd,
                        vertical: AppSizes.paddingSm),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.paddingXs),
              GestureDetector(
                onTap: sending ? null : onSend,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: sending ? AppColors.primary300 : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: sending
                      ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.background),
                        )
                      : const Icon(Icons.send_rounded,
                          size: 20, color: AppColors.background),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
