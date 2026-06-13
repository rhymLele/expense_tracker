import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../../enrollments/data/datasources/enrollments_remote_datasource.dart';
import '../../../enrollments/domain/entities/enrollment_entity.dart';
import '../../../enrollments/domain/entities/today_task_entity.dart';
import '../../../enrollments/presentation/bloc/roadmap_home/roadmap_home_cubit.dart';
import '../../../enrollments/presentation/bloc/roadmap_home/roadmap_home_state.dart';

// ─── Entry ────────────────────────────────────────────────────────────────────

class RoadmapTab extends StatelessWidget {
  const RoadmapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoadmapHomeCubit(
          datasource: sl<EnrollmentsRemoteDataSource>())
        ..load(),
      child: const _RoadmapHomePage(),
    );
  }
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class _RoadmapHomePage extends StatelessWidget {
  const _RoadmapHomePage();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapHomeCubit, RoadmapHomeState>(
      builder: (context, state) {
        if (state.status == RoadmapHomeStatus.loading &&
            state.active == null) {
          return const ColoredBox(
            color: AppColors.bgPage,
            child: Center(
              child: CircularProgressIndicator(
                  color: AppColors.primary, strokeWidth: 2),
            ),
          );
        }

        if (state.status == RoadmapHomeStatus.failure &&
            state.active == null) {
          return ColoredBox(
            color: AppColors.bgPage,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingXl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_outlined,
                        size: 48, color: AppColors.textHint),
                    const SizedBox(height: AppSizes.paddingMd),
                    Text(
                      state.errorMessage ?? 'Không tải được dữ liệu',
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.paddingLg),
                    TextButton(
                      onPressed: () => context
                          .read<RoadmapHomeCubit>()
                          .refresh(),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state.active == null) return const _EmptyState();

        return ColoredBox(
          color: AppColors.bgPage,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              context
                  .read<RoadmapHomeCubit>()
                  .refresh();
              await context
                  .read<RoadmapHomeCubit>()
                  .stream
                  .firstWhere(
                      (s) => s.status != RoadmapHomeStatus.loading);
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _HeroSection(
                    enrollment: state.active!,
                    progress: state.progressFraction,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TodayTasks(
                    tasks: state.active!.todayTasks,
                    completedIds: state.completedTaskIds,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _JourneyPath(enrollment: state.active!),
                ),
                SliverToBoxAdapter(
                  child: _QueueList(
                    queue: state.queue,
                    onCancelTap: () => _confirmCancel(context),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSizes.xxxl * 2)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hủy lộ trình?'),
        content: const Text(
          'Tiến độ sẽ không được lưu. '
          'Lộ trình tiếp theo trong hàng đợi sẽ tự động kích hoạt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: AppColors.error700),
            child: const Text('Hủy lộ trình'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<RoadmapHomeCubit>().cancelEnrollment();
    }
  }
}

// ─── [A] HERO ─────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final EnrollmentEntity enrollment;
  final double progress;

  const _HeroSection(
      {required this.enrollment, required this.progress});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 58, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary700],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: streak + Quản lý
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department_rounded,
                  size: 30, color: AppColors.flameAmber),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${enrollment.streak}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                      height: 1,
                    ),
                  ),
                  Text(
                    'ngày streak',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.background.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _HeroGhostButton(
                  label: 'Quản lý', icon: Icons.settings_outlined),
            ],
          ),
          const SizedBox(height: 18),
          // Row 2: ĐANG HỌC chip + title
          Row(children: [
            _HeroBadge('ĐANG HỌC'),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                enrollment.journeyTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.background.withValues(alpha: 0.9),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          const SizedBox(height: 8),
          // Row 3: roadmap title
          Text(
            enrollment.journeyTitle,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: AppColors.background,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          // Row 4: progress meta + bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày ${enrollment.currentDay} / ${enrollment.journeyTotalDays}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.background.withValues(alpha: 0.95),
                ),
              ),
              Text(
                '$pct% hoàn thành',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.background.withValues(alpha: 0.95),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress bar: 8px, fill white, track white-28%
          ClipRRect(
            borderRadius:
                BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor:
                  AppColors.background.withValues(alpha: 0.28),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.background),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroGhostButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const _HeroGhostButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          // rgba(255,255,255,0.18) from spec
          color: AppColors.background.withValues(alpha: 0.18),
          borderRadius:
              BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.background),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.background)),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  const _HeroBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        // rgba(255,255,255,0.2) from spec
        color: AppColors.background.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: const Text(
        'ĐANG HỌC',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.background,
        ),
      ),
    );
  }
}

// ─── [B] TODAY TASKS ─────────────────────────────────────────────────────────

class _TodayTasks extends StatelessWidget {
  final List<TodayTaskEntity> tasks;
  final Set<String> completedIds;

  const _TodayTasks(
      {required this.tasks, required this.completedIds});

  @override
  Widget build(BuildContext context) {
    final display = tasks.isNotEmpty
        ? tasks
        : const [
            TodayTaskEntity(
                id: 'm1',
                title: 'Phát âm 5 từ chủ đề Travel',
                taskType: 'pronunciation'),
            TodayTaskEntity(
                id: 'm2',
                title: 'Ghi âm câu mẫu 60 giây',
                taskType: 'recording'),
            TodayTaskEntity(
                id: 'm3',
                title: 'Viết đoạn văn 150 từ',
                taskType: 'writing'),
          ];
    final doneCount =
        display.where((t) => completedIds.contains(t.id)).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingLg, 18, AppSizes.paddingLg, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nhiệm vụ hôm nay',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$doneCount/${display.length} hoàn thành',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMd),
          ...display.map((task) => _TaskCard(
                task: task,
                isDone: completedIds.contains(task.id),
              )),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TodayTaskEntity task;
  final bool isDone;
  const _TaskCard({required this.task, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<RoadmapHomeCubit>()
          .toggleTask(task.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            // Checkbox 26px
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? AppColors.primary
                    : AppColors.background,
                border: Border.all(
                  color: isDone
                      ? AppColors.primary
                      : AppColors.strokeStrong,
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: AppColors.background)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDone
                          ? AppColors.textMuted
                          : AppColors.textPrimary,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _SkillChip(label: task.typeLabel),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primary600,
        ),
      ),
    );
  }
}

// ─── [C] JOURNEY PATH ────────────────────────────────────────────────────────

class _JourneyPath extends StatelessWidget {
  final EnrollmentEntity enrollment;
  const _JourneyPath({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final total = enrollment.journeyTotalDays.clamp(1, 30);
    final current = enrollment.currentDay;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingLg, 10, AppSizes.paddingLg, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hành trình của bạn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.paddingLg),
          ...List.generate(total, (i) {
            final day = i + 1;
            final status = day < current
                ? _NodeStatus.done
                : day == current
                    ? _NodeStatus.today
                    : _NodeStatus.locked;
            final subtitle = enrollment.dayTitles.length > i
                ? enrollment.dayTitles[i]
                : '';
            return Column(children: [
              if (i > 0) _NodeConnector(done: day - 1 < current),
              _PathNode(
                  day: day, status: status, subtitle: subtitle),
            ]);
          }),
          const SizedBox(height: AppSizes.paddingSm),
        ],
      ),
    );
  }
}

enum _NodeStatus { done, today, locked }

class _NodeConnector extends StatelessWidget {
  final bool done;
  const _NodeConnector({required this.done});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 3,
        height: 26,
        // primary300 when passed, stroke when not
        color: done ? AppColors.primary300 : AppColors.stroke,
      ),
    );
  }
}

class _PathNode extends StatelessWidget {
  final int day;
  final _NodeStatus status;
  final String subtitle;
  const _PathNode(
      {required this.day,
      required this.status,
      this.subtitle = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "BẮT ĐẦU" pill above today node
        if (status == _NodeStatus.today) ...[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary600,
              borderRadius:
                  BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: const Text(
              'BẮT ĐẦU',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.background),
            ),
          ),
          CustomPaint(
            size: const Size(10, 5),
            painter: _DownArrow(AppColors.primary600),
          ),
          const SizedBox(height: 2),
        ],
        // Node circle 58px
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _bg,
            border: _border,
            boxShadow: _shadow,
          ),
          child: Center(child: _icon),
        ),
        const SizedBox(height: 4),
        Text(
          'Ngày $day',
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted),
        ),
        if (subtitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              subtitle,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textHint),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        const SizedBox(height: 2),
      ],
    );
  }

  Color get _bg => switch (status) {
        _NodeStatus.done => AppColors.primary,
        _NodeStatus.today => AppColors.background,
        _NodeStatus.locked => AppColors.bgMuted,
      };

  BoxBorder? get _border => switch (status) {
        _NodeStatus.done => null,
        _NodeStatus.today =>
          Border.all(color: AppColors.primary, width: 3),
        _NodeStatus.locked =>
          Border.all(color: AppColors.stroke, width: 2),
      };

  // done: solid bottom 3D shadow (0 5px 0 primary700)
  // today: mint soft glow
  List<BoxShadow>? get _shadow => switch (status) {
        _NodeStatus.done => const [
            BoxShadow(
              color: AppColors.primary700,
              offset: Offset(0, 5),
              blurRadius: 0,
            ),
          ],
        _NodeStatus.today => [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        _NodeStatus.locked => null,
      };

  Widget get _icon => switch (status) {
        _NodeStatus.done => const Icon(Icons.check_rounded,
            size: 24, color: AppColors.background),
        _NodeStatus.today => Text(
            'N$day',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary600,
            ),
          ),
        _NodeStatus.locked => const Icon(Icons.route_outlined,
            size: 22, color: AppColors.textHint),
      };
}

class _DownArrow extends CustomPainter {
  final Color color;
  const _DownArrow(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_DownArrow old) => old.color != color;
}

// ─── [D] QUEUE ───────────────────────────────────────────────────────────────

class _QueueList extends StatefulWidget {
  final List<EnrollmentEntity> queue;
  final VoidCallback onCancelTap;
  const _QueueList(
      {required this.queue, required this.onCancelTap});

  @override
  State<_QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<_QueueList> {
  late List<EnrollmentEntity> _local;

  @override
  void initState() {
    super.initState();
    _local = List.from(widget.queue);
  }

  @override
  void didUpdateWidget(_QueueList old) {
    super.didUpdateWidget(old);
    if (old.queue != widget.queue) _local = List.from(widget.queue);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.paddingLg, 14, AppSizes.paddingLg, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hàng đợi lộ trình',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  '+ Khám phá',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Kéo để sắp xếp thứ tự — lộ trình kế tiếp sẽ tự kích hoạt khi bạn hoàn thành.',
            style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          // Reorderable list
          if (_local.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Chưa có lộ trình nào trong hàng đợi',
                  style: AppTextStyles.labelSmall,
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _local.length,
              onReorder: (from, to) {
                setState(() {
                  final item = _local.removeAt(from);
                  _local.insert(
                      to > from ? to - 1 : to, item);
                });
                context.read<RoadmapHomeCubit>().reorderQueue(
                      _local.map((e) => e.id).toList());
              },
              itemBuilder: (_, i) => _QueueCard(
                key: ValueKey(_local[i].id),
                index: i,
                enrollment: _local[i],
              ),
            ),
          const SizedBox(height: AppSizes.paddingMd),
          // Cancel: bgMuted bg, error700 text (spec)
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: widget.onCancelTap,
              style: TextButton.styleFrom(
                backgroundColor: AppColors.bgMuted,
                foregroundColor: AppColors.error700,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusLg),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Hủy lộ trình hiện tại',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  final int index;
  final EnrollmentEntity enrollment;
  const _QueueCard(
      {super.key, required this.index, required this.enrollment});

  static const _thumbColors = [
    AppColors.primary50,
    AppColors.purple50,
    AppColors.warning50,
  ];

  @override
  Widget build(BuildContext context) {
    final thumbBg = _thumbColors[index % _thumbColors.length];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.bgMuted,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: thumbBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.route_outlined,
                color: AppColors.primary600, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollment.journeyTitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${enrollment.journeyTotalDays} ngày',
                  style: const TextStyle(
                      fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const Padding(
            padding:
                EdgeInsets.only(left: AppSizes.paddingSm),
            child: Icon(Icons.drag_handle_rounded,
                size: 20, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.bgPage,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingXl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary50,
                child: Icon(Icons.route_outlined,
                    size: 40, color: AppColors.primary600),
              ),
              SizedBox(height: AppSizes.paddingLg),
              Text(
                'Chưa có lộ trình nào',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.paddingXs),
              Text(
                'Khám phá Feed để tìm và đăng ký\nlộ trình học phù hợp với bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
