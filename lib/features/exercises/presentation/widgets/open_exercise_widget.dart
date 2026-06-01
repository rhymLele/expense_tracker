import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';

/// Shared widget for essay and recording exercises (manual grading).
class OpenExerciseWidget extends StatefulWidget {
  final String question;
  final String prompt;
  final bool isRecording;
  final void Function(Map<String, dynamic> answer) onSubmit;
  final bool enabled;

  const OpenExerciseWidget({
    super.key,
    required this.question,
    required this.prompt,
    this.isRecording = false,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  State<OpenExerciseWidget> createState() => _OpenExerciseWidgetState();
}

class _OpenExerciseWidgetState extends State<OpenExerciseWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSizes.paddingMd),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Icon(
                widget.isRecording
                    ? Icons.mic_outlined
                    : Icons.edit_note_outlined,
                color: AppColors.textSecondary,
                size: AppSizes.iconMd,
              ),
              const SizedBox(width: AppSizes.paddingSm),
              Expanded(
                child: Text(
                  widget.prompt,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.paddingLg),
        if (widget.isRecording) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mic,
                  size: 48,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppSizes.paddingSm),
                Text(
                  'Tính năng ghi âm sẽ được cập nhật sớm',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingXl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.enabled
                  ? () => widget.onSubmit({'recordingUrl': null})
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
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
        ] else ...[
          TextField(
            controller: _controller,
            enabled: widget.enabled,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Viết câu trả lời của bạn...',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide: const BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingXl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.text.trim().isNotEmpty && widget.enabled
                  ? () => widget.onSubmit({'text': _controller.text.trim()})
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
      ],
    );
  }
}
