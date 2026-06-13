import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/base_loading.dart';
import '../../domain/entities/exercise_template_entity.dart';
import '../create_exercise/create_exercise_page.dart';
import 'bloc/template_gallery_cubit.dart';
import 'bloc/template_gallery_state.dart';

class TemplateGalleryPage extends StatelessWidget {
  const TemplateGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TemplateGalleryCubit(datasource: sl())
        ..load(),
      child: const _TemplateGalleryContent(),
    );
  }
}

class _TemplateGalleryContent extends StatelessWidget {
  const _TemplateGalleryContent();

  static const _categories = [
    ('vocabulary', 'Từ vựng', Icons.abc_outlined),
    ('grammar', 'Ngữ pháp', Icons.rule_outlined),
    ('speaking', 'Luyện nói', Icons.mic_outlined),
    ('ielts_speaking', 'IELTS Speaking', Icons.record_voice_over_outlined),
    ('writing', 'Viết', Icons.edit_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Chọn mẫu bài tập', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<TemplateGalleryCubit, TemplateGalleryState>(
        builder: (context, state) {
          if (state.status == TemplateGalleryStatus.loading) {
            return const Center(child: BaseLoading());
          }
          if (state.status == TemplateGalleryStatus.failure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.textHint),
                  const SizedBox(height: AppSizes.paddingMd),
                  Text(
                    state.errorMessage ?? 'Không tải được mẫu',
                    style: AppTextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => context
                        .read<TemplateGalleryCubit>()
                        .load(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _CategoryBar(
                  categories: _categories,
                  selected: state.selectedCategory,
                  onSelected: (cat) => context
                      .read<TemplateGalleryCubit>()
                      .selectCategory(cat),
                ),
              ),
              if (state.filtered.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Không có mẫu nào trong danh mục này',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(AppSizes.paddingLg),
                  sliver: SliverList.separated(
                    itemCount: state.filtered.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSizes.paddingSm),
                    itemBuilder: (ctx, i) {
                      if (i == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppSizes.paddingSm),
                          child: _ScratchCard(
                            onTap: () => Navigator.pushReplacement(
                              ctx,
                              MaterialPageRoute(
                                builder: (_) => const CreateExercisePage(),
                              ),
                            ),
                          ),
                        );
                      }
                      return _TemplateCard(
                        template: state.filtered[i - 1],
                        onTap: () => Navigator.pushReplacement(
                          ctx,
                          MaterialPageRoute(
                            builder: (_) => CreateExercisePage(
                              prefill: state.filtered[i - 1],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.xxxl),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Category Filter Bar ────────────────────────────────────────────────────

class _CategoryBar extends StatelessWidget {
  final List<(String, String, IconData)> categories;
  final String? selected;
  final ValueChanged<String> onSelected;

  const _CategoryBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingLg,
        vertical: AppSizes.paddingMd,
      ),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selected == cat.$1;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.paddingXs),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(cat.$3, size: 14,
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(cat.$2),
                ],
              ),
              onSelected: (_) => onSelected(cat.$1),
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.background,
              labelStyle: TextStyle(
                color: isSelected
                    ? AppColors.background
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.divider,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Template Card ──────────────────────────────────────────────────────────

class _TemplateCard extends StatelessWidget {
  final ExerciseTemplateEntity template;
  final VoidCallback onTap;

  const _TemplateCard({required this.template, required this.onTap});

  static const _typeIcons = {
    'multiple_choice': (Icons.check_circle_outline, 'Trắc nghiệm'),
    'fill_blank': (Icons.text_fields_outlined, 'Điền từ'),
    'arrange': (Icons.swap_horiz_outlined, 'Sắp xếp'),
    'matching': (Icons.compare_arrows_outlined, 'Ghép cặp'),
    'recording': (Icons.mic_outlined, 'Ghi âm'),
    'essay': (Icons.article_outlined, 'Tự luận'),
  };

  @override
  Widget build(BuildContext context) {
    final typeInfo = _typeIcons[template.type] ??
        (Icons.quiz_outlined, template.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(typeInfo.$1,
                  size: AppSizes.iconMd, color: AppColors.primary),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.question.length > 60
                        ? '${template.question.substring(0, 60)}…'
                        : template.question,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _Chip(typeInfo.$2),
                      const SizedBox(width: AppSizes.paddingXs),
                      _Chip(template.categoryLabel),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.paddingSm),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
      ),
    );
  }
}

// ─── Scratch Card (start from blank) ───────────────────────────────────────

class _ScratchCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ScratchCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1.5,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Icon(Icons.add,
                  size: AppSizes.iconMd, color: AppColors.primary),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tạo từ đầu',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Form trống — tự thiết kế bài tập của bạn',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
