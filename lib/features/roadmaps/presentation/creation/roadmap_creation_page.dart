import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import 'bloc/roadmap_creation_cubit.dart';
import 'bloc/roadmap_creation_state.dart';
import 'widgets/day_expansion_tile.dart';
import 'widgets/publish_bar.dart';

class RoadmapCreationPage extends StatelessWidget {
  const RoadmapCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RoadmapCreationCubit()..initialize(),
      child: const _RoadmapCreationContent(),
    );
  }
}

class _RoadmapCreationContent extends StatelessWidget {
  const _RoadmapCreationContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoadmapCreationCubit, RoadmapCreationState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.validationMessage != c.validationMessage,
      listener: (context, state) {
        if (state.status == RoadmapCreationStatus.success) {
          Navigator.pop(context, true);
        } else if (state.status == RoadmapCreationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage ?? 'Đăng thất bại'),
            backgroundColor: AppColors.error,
          ));
        } else if (state.validationMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.validationMessage!),
            backgroundColor: AppColors.warning,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: _buildAppBar(context),
        body: const _Body(),
        bottomNavigationBar: const PublishBar(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Tạo lộ trình', style: AppTextStyles.titleLarge),
      actions: [
        BlocBuilder<RoadmapCreationCubit, RoadmapCreationState>(
          buildWhen: (p, c) =>
              p.isPublishable != c.isPublishable || p.status != c.status,
          builder: (context, state) {
            final loading =
                state.status == RoadmapCreationStatus.publishing;
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  : TextButton(
                      onPressed: () => context
                          .read<RoadmapCreationCubit>()
                          .publish(),
                      child: Text(
                        'Đăng',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: state.isPublishable
                              ? AppColors.primary600
                              : AppColors.textHint,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 1. Preview card
        const SliverToBoxAdapter(child: _PreviewCard()),
        // 2. Cover color picker
        const SliverToBoxAdapter(child: _CoverSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        // 3. Title + Description
        const SliverToBoxAdapter(child: _TitleDescSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        // 4. Subject + Level chips
        const SliverToBoxAdapter(child: _SubjectSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        // 5. Day-by-day content header
        const SliverToBoxAdapter(child: _DaySectionHeader()),
        // 6. Day tiles
        BlocBuilder<RoadmapCreationCubit, RoadmapCreationState>(
          builder: (context, state) {
            return SliverList.builder(
              itemCount: state.days.length,
              itemBuilder: (ctx, i) => RepaintBoundary(
                child: BlocSelector<RoadmapCreationCubit, RoadmapCreationState,
                    RoadmapDayDraft>(
                  selector: (s) =>
                      s.days.length > i ? s.days[i] : const RoadmapDayDraft(),
                  builder: (ctx, day) =>
                      DayExpansionTile(dayIndex: i, day: day),
                ),
              ),
            );
          },
        ),
        // 7. Add day button
        const SliverToBoxAdapter(child: _AddDayButton()),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

// ─── 1. Preview card ──────────────────────────────────────────────────────────

class _PreviewCard extends StatelessWidget {
  const _PreviewCard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RoadmapCreationCubit, RoadmapCreationState,
        _PreviewData>(
      selector: (s) => _PreviewData(
        title: s.title,
        days: s.days.length,
        tasks: s.totalTaskCount,
        levelLabel: s.levelLabel,
        subject: s.subject,
        color: s.coverColor,
        imagePath: s.coverImagePath,
      ),
      builder: (_, data) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: SizedBox(
            height: 140,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background color or image
                data.imagePath != null
                    ? Image.asset(data.imagePath!, fit: BoxFit.cover)
                    : Container(color: data.color),
                // Diagonal stripe overlay
                CustomPaint(painter: _StripePainter()),
                // Gradient overlay for text readability
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x55000000)],
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag
                      if (data.subject != null)
                        _TagPill(data.subject!)
                      else
                        _TagPill('IELTS'),
                      const Spacer(),
                      Text(
                        data.title.isEmpty
                            ? 'Tên lộ trình của bạn'
                            : data.title,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.days} ngày · ${data.tasks} bài tập · ${data.levelLabel}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewData {
  final String title;
  final int days;
  final int tasks;
  final String levelLabel;
  final String? subject;
  final Color color;
  final String? imagePath;

  const _PreviewData({
    required this.title,
    required this.days,
    required this.tasks,
    required this.levelLabel,
    required this.subject,
    required this.color,
    required this.imagePath,
  });

  @override
  bool operator ==(Object other) =>
      other is _PreviewData &&
      title == other.title &&
      days == other.days &&
      tasks == other.tasks &&
      levelLabel == other.levelLabel &&
      subject == other.subject &&
      color == other.color &&
      imagePath == other.imagePath;

  @override
  int get hashCode =>
      Object.hash(title, days, tasks, levelLabel, subject, color, imagePath);
}

class _TagPill extends StatelessWidget {
  final String label;
  const _TagPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.chip.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke;
    const spacing = 28.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripePainter _) => false;
}

// ─── 2. Cover color picker ────────────────────────────────────────────────────

class _CoverSection extends StatelessWidget {
  const _CoverSection();

  static const _colors = [
    AppColors.primary,
    Color(0xFF2A6FDB),
    Color(0xFF764FDB),
    Color(0xFFE37E36),
    Color(0xFF449297),
    Color(0xFFEB5146),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Màu bìa', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          BlocSelector<RoadmapCreationCubit, RoadmapCreationState, Color>(
            selector: (s) => s.coverColor,
            builder: (context, selectedColor) => Row(
              children: [
                // Color circles
                ..._colors.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _ColorCircle(
                        color: c,
                        selected: selectedColor == c,
                        onTap: () => context
                            .read<RoadmapCreationCubit>()
                            .changeCoverColor(c),
                      ),
                    )),
                // Image picker button
                _ImagePickerCircle(
                  onTap: () => _pickImage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(BuildContext context) {
    // TODO: integrate image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chọn ảnh từ thư viện (coming soon)'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _ColorCircle(
      {required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: AppColors.textPrimary, width: 2.5)
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

class _ImagePickerCircle extends StatelessWidget {
  final VoidCallback onTap;
  const _ImagePickerCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.bgMuted,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.stroke),
        ),
        child: const Icon(Icons.add_photo_alternate_outlined,
            size: 20, color: AppColors.textSecondary),
      ),
    );
  }
}

// ─── 3. Title + Description ───────────────────────────────────────────────────

class _TitleDescSection extends StatefulWidget {
  const _TitleDescSection();

  @override
  State<_TitleDescSection> createState() => _TitleDescSectionState();
}

class _TitleDescSectionState extends State<_TitleDescSection> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text('Tên lộ trình', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            maxLength: 70,
            onChanged: (v) => context
                .read<RoadmapCreationCubit>()
                .changeTitle(v),
            style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'VD: IELTS Speaking 7.0 trong 30 ngày',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.bgMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              counterStyle: AppTextStyles.labelSmall,
            ),
          ),
          const SizedBox(height: 14),
          // Description
          const Text('Mô tả ngắn', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            maxLines: 4,
            onChanged: (v) => context
                .read<RoadmapCreationCubit>()
                .changeDescription(v),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Học viên sẽ đạt được gì sau lộ trình này?',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.bgMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.stroke),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 4. Subject + Level ───────────────────────────────────────────────────────

class _SubjectSection extends StatelessWidget {
  const _SubjectSection();

  static const _subjects = [
    'IELTS', 'Phát âm', 'Business', 'Giao tiếp', 'TOEIC', 'Trẻ em',
  ];

  static const _levels = [
    ('beginner', 'Cơ bản'),
    ('intermediate', 'Trung cấp'),
    ('advanced', 'Nâng cao'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: BlocBuilder<RoadmapCreationCubit, RoadmapCreationState>(
        buildWhen: (p, c) => p.subject != c.subject || p.level != c.level,
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            const Text('Chủ đề', style: AppTextStyles.labelLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _subjects
                  .map((s) => _SelectableChip(
                        label: s,
                        selected: state.subject == s,
                        onTap: () => context
                            .read<RoadmapCreationCubit>()
                            .changeSubject(s),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            // Level
            const Text('Cấp độ', style: AppTextStyles.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: _levels
                  .map((l) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _SelectableChip(
                          label: l.$2,
                          selected: state.level == l.$1,
                          onTap: () => context
                              .read<RoadmapCreationCubit>()
                              .changeLevel(l.$1),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SelectableChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.stroke,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color:
                selected ? AppColors.primary600 : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── 5. Day section header ────────────────────────────────────────────────────

class _DaySectionHeader extends StatelessWidget {
  const _DaySectionHeader();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RoadmapCreationCubit, RoadmapCreationState,
        (int, int)>(
      selector: (s) => (s.days.length, s.totalTaskCount),
      builder: (_, data) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Row(
          children: [
            const Text('Nội dung từng ngày',
                style: AppTextStyles.titleLarge),
            const Spacer(),
            Text(
              '${data.$1} ngày · ${data.$2} bài tập',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 6. Add day button ────────────────────────────────────────────────────────

class _AddDayButton extends StatelessWidget {
  const _AddDayButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<RoadmapCreationCubit>().addDay(),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.55),
            width: 1.5,
            // dashed style simulated via solid (CustomPainter needed for true dash)
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          color: AppColors.primary50.withValues(alpha: 0.4),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: AppColors.primary600),
            SizedBox(width: 6),
            Text(
              'Thêm ngày',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

