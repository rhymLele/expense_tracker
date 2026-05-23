import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingLg,
              AppSizes.paddingXl,
              AppSizes.paddingLg,
              AppSizes.paddingSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tin nhắn', style: AppTextStyles.headlineLarge),
                const SizedBox(height: AppSizes.paddingXs),
                Text(
                  'Trò chuyện với giáo viên',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ),
        const SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppColors.textHint,
                ),
                SizedBox(height: AppSizes.paddingMd),
                Text(
                  'Chưa có tin nhắn nào',
                  style: AppTextStyles.bodyMedium,
                ),
                SizedBox(height: AppSizes.paddingXs),
                Text(
                  'Tính năng đang phát triển',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
