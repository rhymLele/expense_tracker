import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/skeletons/app_skeletons.dart';
import '../../../feed/presentation/bloc/feed_bloc.dart';
import '../../../feed/presentation/bloc/feed_event.dart';
import '../../../feed/presentation/bloc/feed_state.dart';
import '../../../feed/presentation/widgets/topic_card.dart';

class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
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
              SliverToBoxAdapter(child: _buildHeader()),
              if (state.status == FeedStatus.loading && state.topics.isEmpty)
                const FeedListSkeleton()
              else if (state.status == FeedStatus.failure &&
                  state.topics.isEmpty)
                SliverFillRemaining(
                  child: _ErrorView(
                    message: state.errorMessage,
                    onRetry: () =>
                        context.read<FeedBloc>().add(const FeedLoadRequested()),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLg,
                  ),
                  sliver: SliverList.separated(
                    itemCount: state.topics.length +
                        (state.hasMore && state.topics.isNotEmpty ? 1 : 0),
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.divider, height: 1),
                    itemBuilder: (ctx, i) {
                      if (i == state.topics.length) {
                        ctx
                            .read<FeedBloc>()
                            .add(const FeedLoadMoreRequested());
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.paddingLg,
                          ),
                          child: Center(child: FeedCardSkeleton()),
                        );
                      }
                      return TopicCard(topic: state.topics[i]);
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxxl)),
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
        AppSizes.paddingMd,
      ),
      child: Text('Feed', style: AppTextStyles.headlineLarge),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;
  const _ErrorView({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                size: 48, color: AppColors.textHint),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              message ?? 'Không tải được dữ liệu',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLg),
            TextButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}
