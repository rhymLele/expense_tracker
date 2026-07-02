import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../lingua_thread/theme/lt_colors.dart';
import '../../../../lingua_thread/theme/lt_spacing.dart';
import '../../../../lingua_thread/theme/lt_typography.dart';
import '../../../../lingua_thread/widgets/lt_avatar.dart';
import '../../domain/usecases/add_topic_comment_usecase.dart';
import '../../domain/usecases/get_topic_comments_usecase.dart';
import '../bloc/comments_cubit.dart';
import '../bloc/comments_state.dart';

void showCommentsSheet(
  BuildContext context, {
  required String topicId,
  required int commentCount,
  VoidCallback? onCommentAdded,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    // Let the sheet sit above the keyboard
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: BlocProvider(
        create: (_) => CommentsCubit(
          getComments: sl<GetTopicCommentsUseCase>(),
          addComment: sl<AddTopicCommentUseCase>(),
          topicId: topicId,
        )..load(),
        child: _CommentsSheet(
          initialCount: commentCount,
          onCommentAdded: onCommentAdded,
        ),
      ),
    ),
  );
}

// ─── Sheet ────────────────────────────────────────────────────────────────────

class _CommentsSheet extends StatefulWidget {
  const _CommentsSheet({
    required this.initialCount,
    this.onCommentAdded,
  });

  final int initialCount;
  final VoidCallback? onCommentAdded;

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _submit(BuildContext ctx) {
    final text = _textCtrl.text;
    if (text.trim().isEmpty) return;
    ctx.read<CommentsCubit>().addComment(text);
    _textCtrl.clear();
    widget.onCommentAdded?.call();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            _buildHandle(),
            _buildHeader(),
            const Divider(height: 1, color: LtColors.divider),
            Expanded(child: _buildList()),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: LtColors.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<CommentsCubit, CommentsState>(
      buildWhen: (p, c) => p.comments.length != c.comments.length,
      builder: (_, state) {
        final count = state.status == CommentsStatus.success
            ? state.comments.length
            : widget.initialCount;
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: LtSpacing.padPage, vertical: 10),
          child: Row(
            children: [
              Text(
                '$count bình luận',
                style: LtTypography.heading.copyWith(fontSize: 15),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 20, color: LtColors.textMuted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList() {
    return BlocConsumer<CommentsCubit, CommentsState>(
      listenWhen: (p, c) => c.comments.length > p.comments.length,
      listener: (_, __) => _scrollToBottom(),
      builder: (ctx, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: LtColors.ink));
        }
        if (state.comments.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💬', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text('Chưa có bình luận',
                    style:
                        LtTypography.body.copyWith(color: LtColors.textMuted)),
                const SizedBox(height: 4),
                Text('Hãy là người đầu tiên!', style: LtTypography.caption),
              ],
            ),
          );
        }
        return ListView.separated(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(
              LtSpacing.padPage, 12, LtSpacing.padPage, 8),
          itemCount: state.comments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, i) {
            final c = state.comments[i];
            final name = c.authorName?.isNotEmpty == true
                ? c.authorName!
                : 'Người dùng';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LtAvatar(name: name, size: 32),
                const SizedBox(width: LtSpacing.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(name, style: LtTypography.smallBold),
                          const Spacer(),
                          Text(_formatAge(c.createdAt),
                              style: LtTypography.caption),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(c.content, style: LtTypography.body),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildInput() {
    return BlocBuilder<CommentsCubit, CommentsState>(
      buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
      builder: (ctx, state) {
        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                LtSpacing.padPage, 8, LtSpacing.padPage, 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: LtColors.divider)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textCtrl,
                    focusNode: _focusNode,
                    style: LtTypography.body,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(ctx),
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      hintStyle: LtTypography.body
                          .copyWith(color: LtColors.textMuted),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: LtColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: LtColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: LtColors.ink),
                      ),
                      filled: true,
                      fillColor: LtColors.bgMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: state.isSubmitting ? null : () => _submit(ctx),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: state.isSubmitting
                          ? LtColors.divider
                          : LtColors.ink,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded,
                            color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatAge(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 1) return 'Vừa xong';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }
}
