import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';

class McqExerciseWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final void Function(Map<String, dynamic> answer) onSubmit;
  final bool enabled;

  const McqExerciseWidget({
    super.key,
    required this.question,
    required this.options,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  State<McqExerciseWidget> createState() => _McqExerciseWidgetState();
}

class _McqExerciseWidgetState extends State<McqExerciseWidget> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.paddingXl),
        ...widget.options.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final isSelected = _selected == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
            child: GestureDetector(
              onTap: widget.enabled
                  ? () => setState(() => _selected = i)
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.all(AppSizes.paddingLg),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.06)
                      : AppColors.surface,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        String.fromCharCode(65 + i),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.paddingMd),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: AppSizes.paddingXl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selected != null && widget.enabled
                ? () => widget.onSubmit({'selectedIndex': _selected})
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              disabledBackgroundColor: AppColors.divider,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
            ),
            child: const Text(
              'Nộp bài',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
