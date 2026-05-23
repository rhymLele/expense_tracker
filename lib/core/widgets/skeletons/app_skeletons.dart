import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

// ─── Base ────────────────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = AppSizes.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

Widget _shimmerWrap(Widget child) => Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceHover,
      child: child,
    );

// ─── Feed Card Skeleton ───────────────────────────────────────────────────────

class FeedCardSkeleton extends StatelessWidget {
  const FeedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _ShimmerBox(width: 32, height: 32, radius: 16),
                const SizedBox(width: AppSizes.paddingSm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBox(width: 100, height: 12),
                    SizedBox(height: 4),
                    _ShimmerBox(width: 60, height: 10),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSm),
            const _ShimmerBox(width: double.infinity, height: 16),
            const SizedBox(height: 6),
            const _ShimmerBox(width: double.infinity, height: 12),
            const SizedBox(height: 4),
            const _ShimmerBox(width: 200, height: 12),
            const SizedBox(height: AppSizes.paddingSm),
            Row(
              children: const [
                _ShimmerBox(width: 40, height: 12),
                SizedBox(width: AppSizes.paddingMd),
                _ShimmerBox(width: 40, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeedListSkeleton extends StatelessWidget {
  const FeedListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      sliver: SliverList.separated(
        itemCount: 5,
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.divider, height: 1),
        itemBuilder: (_, __) => const FeedCardSkeleton(),
      ),
    );
  }
}

// ─── Teacher Card Skeleton ────────────────────────────────────────────────────

class TeacherCardSkeleton extends StatelessWidget {
  const TeacherCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Container(
        margin:
            const EdgeInsets.only(bottom: AppSizes.paddingSm),
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const _ShimmerBox(width: 48, height: 48, radius: 24),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _ShimmerBox(width: 120, height: 14),
                  SizedBox(height: 6),
                  _ShimmerBox(width: 80, height: 11),
                  SizedBox(height: 6),
                  _ShimmerBox(width: 100, height: 11),
                ],
              ),
            ),
            const _ShimmerBox(width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}

class TeacherListSkeleton extends StatelessWidget {
  const TeacherListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      sliver: SliverList.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const TeacherCardSkeleton(),
      ),
    );
  }
}

// ─── Enrollment Card Skeleton ─────────────────────────────────────────────────

class EnrollmentCardSkeleton extends StatelessWidget {
  const EnrollmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      Container(
        margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _ShimmerBox(width: 160, height: 16),
                _ShimmerBox(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSm),
            const _ShimmerBox(width: double.infinity, height: 8, radius: 4),
            const SizedBox(height: AppSizes.paddingSm),
            Row(
              children: const [
                _ShimmerBox(width: 60, height: 12),
                SizedBox(width: AppSizes.paddingMd),
                _ShimmerBox(width: 80, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EnrollmentListSkeleton extends StatelessWidget {
  const EnrollmentListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      sliver: SliverList.builder(
        itemCount: 4,
        itemBuilder: (_, __) => const EnrollmentCardSkeleton(),
      ),
    );
  }
}

// ─── Teacher Profile Skeleton ─────────────────────────────────────────────────

class TeacherProfileSkeleton extends StatelessWidget {
  const TeacherProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          children: [
            const SizedBox(height: AppSizes.paddingXl),
            const _ShimmerBox(width: 80, height: 80, radius: 40),
            const SizedBox(height: AppSizes.paddingMd),
            const _ShimmerBox(width: 140, height: 18),
            const SizedBox(height: AppSizes.paddingSm),
            const _ShimmerBox(width: 100, height: 13),
            const SizedBox(height: AppSizes.paddingMd),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _ShimmerBox(width: 70, height: 13),
                SizedBox(width: AppSizes.paddingMd),
                _ShimmerBox(width: 70, height: 13),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXl),
            const _ShimmerBox(width: double.infinity, height: 44, radius: AppSizes.radiusMd),
            const SizedBox(height: AppSizes.paddingXl),
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBox(width: double.infinity, height: 100, radius: AppSizes.radiusMd),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Topic Detail Skeleton ────────────────────────────────────────────────────

class TopicDetailSkeleton extends StatelessWidget {
  const TopicDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _ShimmerBox(width: 40, height: 40, radius: 20),
                const SizedBox(width: AppSizes.paddingMd),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _ShimmerBox(width: 120, height: 14),
                    SizedBox(height: 4),
                    _ShimmerBox(width: 80, height: 11),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingMd),
            const _ShimmerBox(width: double.infinity, height: 22),
            const SizedBox(height: AppSizes.paddingSm),
            const _ShimmerBox(width: double.infinity, height: 14),
            const SizedBox(height: 6),
            const _ShimmerBox(width: double.infinity, height: 14),
            const SizedBox(height: 6),
            const _ShimmerBox(width: 260, height: 14),
            const SizedBox(height: AppSizes.paddingMd),
            const _ShimmerBox(width: double.infinity, height: 200, radius: AppSizes.radiusMd),
            const SizedBox(height: AppSizes.paddingMd),
            Row(
              children: const [
                _ShimmerBox(width: 50, height: 14),
                SizedBox(width: AppSizes.paddingMd),
                _ShimmerBox(width: 50, height: 14),
              ],
            ),
            const SizedBox(height: AppSizes.paddingXl),
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ShimmerBox(width: 32, height: 32, radius: 16),
                    const SizedBox(width: AppSizes.paddingSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ShimmerBox(width: 100, height: 12),
                          SizedBox(height: 4),
                          _ShimmerBox(width: double.infinity, height: 12),
                          SizedBox(height: 4),
                          _ShimmerBox(width: 180, height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
