import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/skeletons/app_skeletons.dart';
import '../../../enrollments/domain/entities/enrollment_entity.dart';
import '../../../enrollments/presentation/bloc/enrollments_cubit.dart';
import '../../../enrollments/presentation/bloc/enrollments_state.dart';
import '../../../enrollments/presentation/widgets/enrollment_card.dart';
import '../../../enrollments/presentation/widgets/focus_card.dart';

class MyLearningTab extends StatelessWidget {
  const MyLearningTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<EnrollmentsCubit>()..load(),
      child: const _MyLearningContent(),
    );
  }
}

class _MyLearningContent extends StatelessWidget {
  const _MyLearningContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnrollmentsCubit, EnrollmentsState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            context
                .read<EnrollmentsCubit>()
                .refresh();
            await context
                .read<EnrollmentsCubit>()
                .stream
                .firstWhere((s) => s.status != EnrollmentsStatus.loading);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              if (state.status == EnrollmentsStatus.success &&
                  state.enrollments.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildFocusCard(state.enrollments),
                ),
              if (state.status == EnrollmentsStatus.loading)
                const EnrollmentListSkeleton()
              else if (state.status == EnrollmentsStatus.failure)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.paddingXl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.textHint),
                          const SizedBox(height: AppSizes.paddingMd),
                          Text(
                            state.errorMessage ?? 'Không tải được dữ liệu',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSizes.paddingLg),
                          TextButton(
                            onPressed: () => context
                                .read<EnrollmentsCubit>()
                                .load(),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (state.enrollments.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school_outlined,
                            size: 64, color: AppColors.textHint),
                        SizedBox(height: AppSizes.paddingMd),
                        Text(
                          'Bạn chưa tham gia hành trình nào',
                          style: AppTextStyles.bodyMedium,
                        ),
                        SizedBox(height: AppSizes.paddingXs),
                        Text(
                          'Khám phá và đăng ký hành trình học tập ngay!',
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.paddingLg,
                      AppSizes.paddingSm,
                      AppSizes.paddingLg,
                      AppSizes.paddingXs,
                    ),
                    child: Text(
                      'Tất cả hành trình',
                      style: AppTextStyles.labelMedium,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.enrollments.length,
                    itemBuilder: (_, i) =>
                        EnrollmentCard(enrollment: state.enrollments[i]),
                  ),
                ),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSizes.xxxl),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingXl,
        AppSizes.paddingLg,
        AppSizes.paddingSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Học tập của tôi', style: AppTextStyles.headlineLarge),
          SizedBox(height: AppSizes.paddingXs),
          Text(
            'Các hành trình đang tham gia',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildFocusCard(List<EnrollmentEntity> enrollments) {
    final active = enrollments.firstWhere(
      (e) => e.completedAt == null,
      orElse: () => enrollments.first,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMd),
      child: FocusCard(enrollment: active),
    );
  }
}
