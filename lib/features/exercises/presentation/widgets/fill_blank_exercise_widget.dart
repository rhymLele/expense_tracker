import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';

class FillBlankExerciseWidget extends StatefulWidget {
  final String question;
  final String template;
  final void Function(Map<String, dynamic> answer) onSubmit;
  final bool enabled;

  const FillBlankExerciseWidget({
    super.key,
    required this.question,
    required this.template,
    required this.onSubmit,
    this.enabled = true,
  });

  @override
  State<FillBlankExerciseWidget> createState() =>
      _FillBlankExerciseWidgetState();
}

class _FillBlankExerciseWidgetState extends State<FillBlankExerciseWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<InlineSpan> _buildTemplateSpans() {
    final parts = widget.template.split('___');
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i]));
      if (i < parts.length - 1) {
        spans.add(const WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: _BlankPlaceholder(),
          ),
        ));
      }
    }
    return spans;
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
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.8,
              ),
              children: _buildTemplateSpans(),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingLg),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'Điền vào chỗ trống',
            hintText: 'Nhập câu trả lời...',
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
                ? () => widget.onSubmit({'value': _controller.text.trim()})
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

class _BlankPlaceholder extends StatelessWidget {
  const _BlankPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 2,
      color: AppColors.primary,
    );
  }
}
