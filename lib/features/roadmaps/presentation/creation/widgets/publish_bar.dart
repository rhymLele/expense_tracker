import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/constants/text_styles.dart';
import '../bloc/roadmap_creation_bloc.dart';
import '../bloc/roadmap_creation_event.dart';
import '../bloc/roadmap_creation_state.dart';

class PublishBar extends StatelessWidget {
  const PublishBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoadmapCreationBloc, RoadmapCreationState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSizes.paddingLg,
            AppSizes.paddingMd,
            AppSizes.paddingLg,
            AppSizes.paddingMd + MediaQuery.viewPaddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.stroke)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Validation error badge
              if (state.validationMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMd,
                    vertical: AppSizes.paddingXs,
                  ),
                  margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
                  decoration: BoxDecoration(
                    color: AppColors.error50,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    state.validationMessage!,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.error700),
                  ),
                ),
              Row(
                children: [
                  // Auto-save indicator
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          state.draftSaved ? Icons.cloud_done_outlined : Icons.sync,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.draftSaved ? 'Đã lưu nháp' : 'Đang lưu…',
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  // Inside Row → must override global minimumSize(infinity) from theme
                  ElevatedButton(
                    onPressed: state.isPublishable
                        ? () => context
                            .read<RoadmapCreationBloc>()
                            .add(const RoadmapPublishRequested())
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary300,
                      foregroundColor: AppColors.background,
                      minimumSize: const Size(0, AppSizes.buttonHeight), // 0 width = wrap content
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.paddingXl,
                      ),
                    ),
                    child: const Text('Đăng lộ trình', style: AppTextStyles.labelLarge),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
