import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lingua_thread/data/lt_models.dart';
import '../../../lingua_thread/theme/lt_colors.dart';
import '../../../lingua_thread/theme/lt_spacing.dart';
import '../../../lingua_thread/theme/lt_typography.dart';
import '../../../lingua_thread/widgets/lt_avatar.dart';
import '../../../lingua_thread/widgets/lt_filter_pill.dart';
import '../../../lingua_thread/widgets/lt_gemma_chip.dart';
import '../../../lingua_thread/widgets/lt_tag_chip.dart';
import '../../feed/presentation/bloc/feed_cubit.dart';
import '../../../core/base/base_state.dart';
import '../../../core/widgets/sliver_async.dart';
import '../../feed/presentation/bloc/feed_state.dart';
import '../../topics/domain/entities/topic_entity.dart';
import '../../topics/presentation/search_page.dart';
import '../../topics/presentation/widgets/comments_sheet.dart';
import '../../posts/presentation/create_tab.dart';

// ─── Local UI-only filter enum ─────────────────────────────────────────────────

enum FeedFilter { forYou, following, threads, posts }

// ─── Page ─────────────────────────────────────────────────────────────────────

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) => const _FeedView();
}

// ─── View ─────────────────────────────────────────────────────────────────────

class _LoadMoreSliver extends StatelessWidget {
  const _LoadMoreSliver();

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(child: CircularProgressIndicator(color: LtColors.ink)),
    ),
  );
}

class _FeedView extends StatefulWidget {
  const _FeedView();

  @override
  State<_FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<_FeedView> {
  FeedFilter _filter = FeedFilter.forYou;
  final _scrollController = ScrollController();

  static const _filters = [
    (FeedFilter.forYou, 'For You'),
    (FeedFilter.following, 'Following'),
    (FeedFilter.threads, '🧵 Threads'),
    (FeedFilter.posts, '📝 Posts'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FeedCubit>().loadMore();
    }
  }

  // Capture refs before async gap to avoid "context across async gaps" issue
  Future<void> _openCreate() async {
    final feedCubit = context.read<FeedCubit>();
    final didPost = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const CreateTab(),
      ),
    );
    if (didPost == true && mounted) {
      feedCubit.refresh();
    }
  }

  LtPost _topicToPost(TopicEntity t, {bool liked = false}) => LtPost(
    id: t.id,
    authorName: t.authorName ?? 'Unknown',
    authorGemma: 0,
    createdAt: _formatAge(t.createdAt),
    body: t.content?.isNotEmpty == true ? t.content! : t.title,
    tags: const [],
    likeCount: t.likeCount,
    commentCount: t.commentCount,
    liked: liked,
  );

  static String _formatAge(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }

  // Bài mẫu (seed) khi feed rỗng.
  Widget _seedSliver() => SliverList(
    delegate: SliverChildBuilderDelegate(
      (ctx, i) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PostCard(post: _kSeedPosts[i], onLike: () {}, onComment: () {}),
          const Divider(height: 1, thickness: 1, color: LtColors.divider),
        ],
      ),
      childCount: _kSeedPosts.length,
    ),
  );

  // Danh sách bài thật.
  Widget _postsSliver(BuildContext context, FeedState state) => SliverList(
    delegate: SliverChildBuilderDelegate((ctx, i) {
      final topic = state.topics[i];
      final liked = state.likedTopicIds.contains(topic.id);
      final post = _topicToPost(topic, liked: liked);
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PostCard(
            post: post,
            onLike: () => context.read<FeedCubit>().likePost(topic.id),
            onComment: () => showCommentsSheet(
              context,
              topicId: topic.id,
              commentCount: topic.commentCount,
              onCommentAdded: () =>
                  context.read<FeedCubit>().incrementCommentCount(topic.id),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: LtColors.divider),
        ],
      );
    }, childCount: state.topics.length),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedCubit, FeedState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: LtColors.bg,
          body: RefreshIndicator(
            onRefresh: () => context.read<FeedCubit>().refresh(),
            color: LtColors.ink,
            child: CustomScrollView(
              controller: _scrollController,
              // Required so RefreshIndicator triggers even when content < viewport
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── App bar ───────────────────────────────────────────
                SliverAppBar(
                  floating: true,
                  snap: true,
                  pinned: false,
                  backgroundColor: LtColors.bg,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Text('LinguaThread', style: LtTypography.pageTitle),
                      const SizedBox(width: LtSpacing.gapSm),
                      const LtStreakChip(days: 7),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: LtColors.ink,
                        size: 24,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchPage()),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      height: 48,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: LtColors.divider),
                        ),
                      ),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: LtSpacing.padPage,
                          vertical: 8,
                        ),
                        children: _filters.map((f) {
                          final (filter, label) = f;
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: LtSpacing.gapSm,
                            ),
                            child: LtFilterPill(
                              label: label,
                              active: _filter == filter,
                              onTap: () => setState(() => _filter = filter),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // ── Trạng thái load: loading / lỗi / nội dung ─────────
                ...sliverAsync(
                  loading: state.isInitialLoading,
                  error: state.isInitialError,
                  onRetry: () => context.read<FeedCubit>().load(),
                  errorText: 'Không tải được feed',
                  color: LtColors.ink,
                  data: () => [
                    SliverToBoxAdapter(child: _ComposeBar(onTap: _openCreate)),
                    if (state.showSeedPosts)
                      _seedSliver()
                    else ...[
                      _postsSliver(context, state),
                      if (state.status.isLoadingMore) const _LoadMoreSliver(),
                    ],
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Seed posts (shown to new users when feed is empty) ──────────────────────

final _kSeedPosts = [
  LtPost(
    id: 'seed_1',
    authorName: 'LinguaThread',
    authorGemma: 0,
    createdAt: '2d',
    body:
        '🌟 Chào mừng đến với LinguaThread! Đây là nơi cộng đồng học ngôn ngữ chia sẻ kiến thức, mẹo học, và hỗ trợ lẫn nhau. Theo dõi các chủ đề yêu thích để cá nhân hóa feed của bạn nhé!',
    tags: const ['#welcome', '#community'],
    likeCount: 42,
    commentCount: 8,
    liked: false,
  ),
  LtPost(
    id: 'seed_2',
    authorName: 'Tip of the Day',
    authorGemma: 0,
    createdAt: '1d',
    body:
        '💡 Mẹo học tiếng Anh: Thay vì học từ vựng đơn lẻ, hãy học theo cụm từ (collocations). Ví dụ: "make a decision" thay vì chỉ học "decision". Cách này giúp bạn nói tự nhiên hơn rất nhiều!',
    tags: const ['#vocabulary', '#tips'],
    likeCount: 128,
    commentCount: 24,
    liked: false,
  ),
  LtPost(
    id: 'seed_3',
    authorName: 'IELTS Insider',
    authorGemma: 0,
    createdAt: '3d',
    body:
        '📝 IELTS Writing Task 2: Nhiều bạn hay mắc lỗi viết câu mở đầu quá phức tạp. Hãy nhớ: paraphrase đề bài trong 1-2 câu, rồi nêu thesis statement rõ ràng. Band 7+ không cần câu hoa mỹ — cần lập luận mạch lạc!',
    tags: const ['#ielts', '#writing'],
    likeCount: 87,
    commentCount: 15,
    liked: false,
  ),
  LtPost(
    id: 'seed_4',
    authorName: 'Grammar Corner',
    authorGemma: 0,
    createdAt: '4d',
    body:
        '"I have went" ❌ → "I have gone" ✅\n"She don\'t know" ❌ → "She doesn\'t know" ✅\n\nNhững lỗi cơ bản này rất phổ biến. Chia sẻ để cộng đồng cùng tránh nhé! 💪',
    tags: const ['#grammar', '#english'],
    likeCount: 203,
    commentCount: 41,
    liked: false,
  ),
];

// ─── Compose bar ──────────────────────────────────────────────────────────────

class _ComposeBar extends StatelessWidget {
  const _ComposeBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: LtSpacing.padPage,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: LtColors.divider)),
        ),
        child: Row(
          children: [
            const LtAvatar(name: 'Me', size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: LtColors.bgMuted,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: LtColors.divider),
                ),
                child: Text(
                  'Bạn đang nghĩ gì?',
                  style: LtTypography.body.copyWith(color: LtColors.textLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Post card ────────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.onLike,
    required this.onComment,
  });

  final LtPost post;
  final VoidCallback onLike;
  final VoidCallback onComment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(LtSpacing.padPage),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LtAvatar(name: post.authorName, size: 36),
              const SizedBox(width: LtSpacing.gapMd),
              Expanded(
                child: Row(
                  children: [
                    Text(post.authorName, style: LtTypography.bodyBold),
                    const SizedBox(width: LtSpacing.gapSm),
                    LtGemmaChip(value: post.authorGemma),
                    const Spacer(),
                    Text(post.createdAt, style: LtTypography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: LtSpacing.gapMd),
          Text(post.body, style: LtTypography.body),
          if (post.tags.isNotEmpty) ...[
            const SizedBox(height: LtSpacing.gapSm),
            Wrap(
              spacing: LtSpacing.gapSm,
              runSpacing: LtSpacing.gapSm,
              children: post.tags.map((t) => LtTagChip(tag: t)).toList(),
            ),
          ],
          const SizedBox(height: LtSpacing.gapLg),
          // Actions
          Row(
            children: [
              _ActionBtn(
                icon: post.liked ? Icons.favorite : Icons.favorite_border,
                label: '${post.likeCount}',
                color: post.liked ? Colors.red : LtColors.textMuted,
                onTap: onLike,
              ),
              const SizedBox(width: 20),
              _ActionBtn(
                icon: Icons.chat_bubble_outline,
                label: '${post.commentCount}',
                color: LtColors.textMuted,
                onTap: onComment,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  '◆ Gift Gemma',
                  style: LtTypography.smallBold.copyWith(
                    color: LtColors.gemmaText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(label, style: LtTypography.smallMed.copyWith(color: color)),
        ],
      ),
    );
  }
}
