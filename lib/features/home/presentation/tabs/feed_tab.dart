import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../../../../core/router/app_router.dart';
import '../../../feed/presentation/bloc/feed_bloc.dart';
import '../../../feed/presentation/bloc/feed_event.dart';
import '../../../feed/presentation/bloc/feed_state.dart';
import '../../../topics/data/models/topic_model.dart';
import '../../../topics/domain/entities/topic_entity.dart';

class FeedTab extends StatelessWidget {
  final FeedBloc? bloc;
  const FeedTab({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    if (bloc != null) {
      return BlocProvider.value(value: bloc!, child: const _FeedContent());
    }
    return BlocProvider(
      create: (_) => sl<FeedBloc>()..add(const FeedLoadRequested()),
      child: const _FeedContent(),
    );
  }
}

class _FeedContent extends StatelessWidget {
  const _FeedContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context.read<FeedBloc>().add(const FeedRefreshRequested());
            await context
                .read<FeedBloc>()
                .stream
                .firstWhere((s) => s.status != FeedStatus.loading);
          },
          child: CustomScrollView(
            slivers: [
              // ── Blur AppBar ──────────────────────────────────────────
              const _FeedAppBar(),

              // ── Live banner ──────────────────────────────────────────
              const SliverToBoxAdapter(child: _LiveCard()),

              // ── Suggested teachers ───────────────────────────────────
              const SliverToBoxAdapter(child: _DiscoverRail()),

              // ── Section label ────────────────────────────────────────
              const SliverToBoxAdapter(child: _SectionLabel('BẢNG TIN')),

              // ── Posts ────────────────────────────────────────────────
              if (state.status == FeedStatus.loading && state.topics.isEmpty)
                const SliverToBoxAdapter(child: _MockPostList())
              else if (state.status == FeedStatus.failure &&
                  state.topics.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorView(
                    message: state.errorMessage,
                    onRetry: () => context
                        .read<FeedBloc>()
                        .add(const FeedLoadRequested()),
                  ),
                )
              else if (state.topics.isNotEmpty)
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  sliver: SliverList.separated(
                    itemCount: state.topics.length +
                        (state.hasMore && state.topics.isNotEmpty ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 14),
                    itemBuilder: (ctx, i) {
                      if (i == state.topics.length) {
                        ctx
                            .read<FeedBloc>()
                            .add(const FeedLoadMoreRequested());
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary)),
                        );
                      }
                      return _PostCard(topic: state.topics[i]);
                    },
                  ),
                )
              else
                const SliverToBoxAdapter(child: _MockPostList()),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _FeedAppBar extends StatelessWidget {
  const _FeedAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _BlurAppBarDelegate(),
    );
  }
}

class _BlurAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 64,
          color: AppColors.background.withValues(alpha: 0.86),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Wordmark
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x665CC691),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: const Icon(Icons.route_outlined,
                        size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LearnSpace',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Action icons
              _IconBtn(
                icon: Icons.search_outlined,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _SearchPage(),
                    fullscreenDialog: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              _IconBtn(
                icon: Icons.notifications_outlined,
                onTap: () {},
                badge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_BlurAppBarDelegate old) => false;
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;
  const _IconBtn({required this.icon, required this.onTap, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.iconBtnSize,
        height: AppSizes.iconBtnSize,
        decoration: BoxDecoration(
          color: AppColors.bgMuted,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(icon,
                  size: AppSizes.iconMd, color: AppColors.textSecondary),
            ),
            if (badge)
              Positioned(
                top: 8,
                right: 9,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgMuted, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Live card ────────────────────────────────────────────────────────────────

class _LiveCard extends StatelessWidget {
  const _LiveCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1B3D), Color(0xFF4F2EA3)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Row(
        children: [
          // Avatar with ring
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.error, width: 2),
            ),
            child: _Avatar(
              user: MockData.users['linh']!,
              size: 44,
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LiveBadge(),
                const SizedBox(height: 4),
                const Text(
                  'Cô Linh Trang đang livestream',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Sửa lỗi phát âm cho người đi làm · 312 đang xem',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Enter button
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              child: const Text('Vào xem'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _fade = Tween<double>(begin: 1.0, end: 0.25).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fade,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'LIVE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Discover rail ────────────────────────────────────────────────────────────

class _DiscoverRail extends StatelessWidget {
  const _DiscoverRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Gia sư gợi ý cho bạn',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Bản đồ gia sư',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 14),
            itemCount: MockData.suggestedTeachers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final user =
                  MockData.users[MockData.suggestedTeachers[i]]!;
              return _TeacherCard(user: user);
            },
          ),
        ),
      ],
    );
  }
}

class _TeacherCard extends StatefulWidget {
  final MockUser user;
  const _TeacherCard({required this.user});

  @override
  State<_TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<_TeacherCard> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Avatar(user: widget.user, size: 56, ring: true),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.user.verified) ...[
                const SizedBox(width: 3),
                const Icon(Icons.verified,
                    size: 13, color: AppColors.info),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            widget.user.role,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textMuted,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.user.followers} người theo dõi',
            style: const TextStyle(
                fontSize: 11, color: AppColors.textHint),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => _following = !_following),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _following ? AppColors.primary : AppColors.background,
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _following ? Icons.check : Icons.add,
                    size: 14,
                    color: _following ? Colors.white : AppColors.primary600,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _following ? 'Đang theo dõi' : 'Theo dõi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _following
                          ? Colors.white
                          : AppColors.primary600,
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
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textHint,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ─── Post card (real TopicEntity) ─────────────────────────────────────────────

class _PostCard extends StatefulWidget {
  final TopicEntity topic;
  const _PostCard({required this.topic});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final likeCount = widget.topic.likeCount + (_liked ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _InitialsAvatar(
                initials: widget.topic.teacherId.isNotEmpty
                    ? widget.topic.teacherId[0].toUpperCase()
                    : 'T',
                color: AppColors.primary,
                size: 44,
                online: true,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Giáo viên',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _timeAgo(widget.topic.createdAt),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz,
                  size: 20, color: AppColors.textHint),
            ],
          ),
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topic.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                if (widget.topic.content != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.topic.content!,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // Footer actions
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: AppColors.strokeSoft)),
            ),
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 14),
            child: Row(
              children: [
                _ActionBtn(
                  icon: _liked
                      ? Icons.favorite
                      : Icons.favorite_border,
                  label: '$likeCount',
                  active: _liked,
                  activeColor: AppColors.error,
                  onTap: () => setState(() => _liked = !_liked),
                ),
                const SizedBox(width: 20),
                _ActionBtn(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.topic.commentCount}',
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.topicDetail,
                    arguments: widget.topic.id,
                  ),
                ),
                const SizedBox(width: 20),
                _ActionBtn(
                  icon: Icons.share_outlined,
                  onTap: () => _sharePost(context),
                ),
                const Spacer(),
                _ActionBtn(
                  icon: _saved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  active: _saved,
                  activeColor: AppColors.primary600,
                  onTap: () => setState(() => _saved = !_saved),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }

  void _sharePost(BuildContext context) {
    final text = '${widget.topic.title}'
        '${widget.topic.content != null ? '\n\n${widget.topic.content}' : ''}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép bài viết vào clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    this.label,
    this.active = false,
    this.activeColor = AppColors.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : AppColors.textMuted;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          if (label != null) ...[
            const SizedBox(width: 6),
            Text(
              label!,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Mock post list (shown while loading or feed empty) ───────────────────────

class _MockPostList extends StatelessWidget {
  const _MockPostList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
          child: Column(
            children: MockData.feed
                .map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MockPostCard(post: p),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MockPostCard extends StatefulWidget {
  final MockPost post;
  const _MockPostCard({required this.post});

  @override
  State<_MockPostCard> createState() => _MockPostCardState();
}

class _MockPostCardState extends State<_MockPostCard> {
  late bool _liked;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _liked = widget.post.liked;
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.users[widget.post.userId]!;
    final likeCount =
        widget.post.likes + (_liked && !widget.post.liked ? 1 : 0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              _Avatar(user: user, size: 44, online: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (user.verified) ...[
                          const SizedBox(width: 3),
                          const Icon(Icons.verified,
                              size: 13, color: AppColors.info),
                        ],
                      ],
                    ),
                    Text(
                      '${user.role} · ${widget.post.time} trước',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz,
                  size: 20, color: AppColors.textHint),
            ],
          ),
          // Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              widget.post.text,
              style: const TextStyle(
                fontSize: 14.5,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
          // Image block
          if (widget.post.image != null) ...[
            _ImageBlock(type: widget.post.image!),
            const SizedBox(height: 10),
          ],
          // Roadmap card
          if (widget.post.roadmapId != null) ...[
            _RoadmapCard(
              roadmap: MockData.roadmaps[widget.post.roadmapId!]!,
            ),
            const SizedBox(height: 10),
          ],
          // Footer
          Container(
            decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: AppColors.strokeSoft)),
            ),
            padding: const EdgeInsets.fromLTRB(2, 6, 2, 14),
            child: Row(
              children: [
                _ActionBtn(
                  icon: _liked ? Icons.favorite : Icons.favorite_border,
                  label: '$likeCount',
                  active: _liked,
                  activeColor: AppColors.error,
                  onTap: () => setState(() => _liked = !_liked),
                ),
                const SizedBox(width: 20),
                _ActionBtn(
                  icon: Icons.chat_bubble_outline,
                  label: '${widget.post.comments}',
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                _ActionBtn(icon: Icons.share_outlined, onTap: () {}),
                const Spacer(),
                _ActionBtn(
                  icon: _saved ? Icons.bookmark : Icons.bookmark_border,
                  active: _saved,
                  activeColor: AppColors.primary600,
                  onTap: () => setState(() => _saved = !_saved),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Image blocks ─────────────────────────────────────────────────────────────

class _ImageBlock extends StatelessWidget {
  final String type;
  const _ImageBlock({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == 'accent') {
      return Container(
        height: 190,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A6FDB), Color(0xFF1F4FA6)],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow,
                size: 32, color: Colors.white),
          ),
        ),
      );
    }
    // streak
    return Container(
      height: 190,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE37E36), Color(0xFFEB5146)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department,
              size: 52, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            '7',
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'ngày streak',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ─── Roadmap preview card ─────────────────────────────────────────────────────

class _RoadmapCard extends StatelessWidget {
  final MockRoadmap roadmap;
  const _RoadmapCard({required this.roadmap});

  @override
  Widget build(BuildContext context) {
    final author = MockData.users[roadmap.authorId];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Banner
          Container(
            height: 92,
            color: roadmap.color,
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      roadmap.tag,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.32),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Text(
                      '${roadmap.days} ngày',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  roadmap.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  roadmap.blurb,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 13, color: AppColors.warning),
                    const SizedBox(width: 3),
                    Text(
                      roadmap.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${roadmap.votes} đánh giá',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${roadmap.learners} đang học',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                if (author != null) ...[
                  const Divider(
                      color: AppColors.strokeSoft, height: 22),
                  Row(
                    children: [
                      _Avatar(user: author, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        author.name,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (author.verified) ...[
                        const SizedBox(width: 3),
                        const Icon(Icons.verified,
                            size: 12, color: AppColors.info),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared micro-widgets ─────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final MockUser user;
  final double size;
  final bool online;
  final bool ring;
  const _Avatar({
    required this.user,
    required this.size,
    this.online = false,
    this.ring = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: user.color,
      child: Text(
        user.avatar,
        style: TextStyle(
          fontSize: size * 0.3,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    if (ring) {
      avatar = Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: AppColors.primary300, width: 2),
        ),
        child: avatar,
      );
    }

    if (!online) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: -1,
          right: -1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  final bool online;
  const _InitialsAvatar({
    required this.initials,
    required this.color,
    required this.size,
    this.online = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.3,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );

    if (!online) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          bottom: -1,
          right: -1,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Error view ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: AppSizes.md),
            Text(
              message ?? 'Không tải được dữ liệu',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            TextButton(
                onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

// ─── Search Page ──────────────────────────────────────────────────────────────

class _SearchPage extends StatefulWidget {
  const _SearchPage();

  @override
  State<_SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<_SearchPage> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<TopicEntity> _results = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ctrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) {
      setState(() { _results = []; _error = null; });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(q.trim()));
  }

  Future<void> _search(String q) async {
    setState(() { _loading = true; _error = null; });
    try {
      final ds = _SearchDataSource();
      final results = await ds.search(q);
      if (mounted) setState(() { _results = results; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 0,
        title: TextField(
          controller: _ctrl,
          autofocus: true,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bài viết, lộ trình...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
            border: InputBorder.none,
          ),
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          if (_ctrl.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.textHint),
              onPressed: () {
                _ctrl.clear();
                _onChanged('');
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_ctrl.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.textHint),
            const SizedBox(height: AppSizes.paddingMd),
            Text('Nhập từ khoá để tìm kiếm',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    if (_loading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary));
    }
    if (_error != null) {
      return Center(child: Text('Lỗi: $_error', style: AppTextStyles.bodySmall));
    }
    if (_results.isEmpty) {
      return Center(
        child: Text('Không tìm thấy kết quả cho "${_ctrl.text}"',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(color: AppColors.divider, height: 1),
      itemBuilder: (ctx, i) {
        final topic = _results[i];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.paddingSm),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(Icons.article_outlined, color: AppColors.textSecondary, size: 20),
          ),
          title: Text(
            topic.title,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: topic.content != null
              ? Text(
                  topic.content!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall,
                )
              : null,
          onTap: () => Navigator.pushNamed(
            ctx,
            AppRoutes.topicDetail,
            arguments: topic.id,
          ),
        );
      },
    );
  }
}

class _SearchDataSource extends BaseRemoteDataSource {
  Future<List<TopicEntity>> search(String q) async {
    final res = await baseSendRequest(
      ApiConstants.topics,
      HttpMethod.get,
      queryParameters: {'search': q, 'limit': 20},
    );
    final raw = res['data'];
    List items;
    if (raw is List) {
      items = raw;
    } else if (raw is Map) {
      items = (raw['items'] ?? raw['data'] ?? []) as List;
    } else {
      items = [];
    }
    return items.map((e) => TopicModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
