import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';

class JourneysTab extends StatelessWidget {
  const JourneysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildSection('Đang học')),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          sliver: SliverList.builder(
            itemCount: 2,
            itemBuilder: (_, i) => _EnrolledJourneyCard(index: i),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildSection('Khám phá hành trình'),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
          sliver: SliverList.builder(
            itemCount: 4,
            itemBuilder: (_, i) => _JourneyCard(index: i),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxxl)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingXl,
        AppSizes.paddingLg,
        AppSizes.paddingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hành trình', style: AppTextStyles.headlineLarge),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            'Lộ trình học tập của bạn',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        AppSizes.paddingLg,
        AppSizes.paddingSm,
      ),
      child: Text(title, style: AppTextStyles.titleLarge),
    );
  }
}

class _EnrolledJourneyCard extends StatelessWidget {
  final int index;
  const _EnrolledJourneyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final progress = (index + 1) * 30.0 / 100;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hành trình ${index + 1}',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.background,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            'Ngày ${(index + 1) * 5} / 30',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.background.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSizes.paddingMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.background.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.background),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            '${(progress * 100).round()}% hoàn thành',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.background.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyCard extends StatelessWidget {
  final int index;
  const _JourneyCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingSm),
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
              color: AppColors.surfaceHover,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: const Icon(Icons.route_outlined,
                size: AppSizes.iconMd, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSizes.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hành trình ${index + 3}',
                    style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSizes.paddingXs),
                Text(
                  '30 ngày · Bởi Teacher ${index + 1}',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.textHint, size: AppSizes.iconMd),
        ],
      ),
    );
  }
}
