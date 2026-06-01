import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/constants/text_styles.dart';
import '../bloc/roadmap_creation_event.dart';

/// Bottom sheet để tạo 1 task mới trong 1 ngày.
class TaskFactorySheet extends StatefulWidget {
  const TaskFactorySheet({super.key});

  @override
  State<TaskFactorySheet> createState() => _TaskFactorySheetState();
}

class _TaskFactorySheetState extends State<TaskFactorySheet> {
  SkillType _type = SkillType.listening;
  GradingMethod _grading = GradingMethod.auto;
  bool _required = true;

  final _titleCtrl = TextEditingController();
  // MCQ
  final List<TextEditingController> _options = [
    TextEditingController(), TextEditingController(),
  ];
  int _correctIndex = 0;
  // Essay / Recording
  final _promptCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    for (final c in _options) { c.dispose(); }
    _promptCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      padding: EdgeInsets.fromLTRB(AppSizes.paddingLg, AppSizes.paddingMd, AppSizes.paddingLg, AppSizes.paddingLg + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(color: AppColors.stroke, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
            )),
            const SizedBox(height: AppSizes.paddingMd),
            const Text('Thêm bài tập', style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSizes.paddingLg),

            // Task title
            TextField(
              controller: _titleCtrl,
              decoration: _fieldDeco('Tiêu đề bài tập...'),
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSizes.paddingLg),

            // Task type segmented
            const Text('Loại bài tập', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSizes.paddingXs),
            _SegmentedRow<SkillType>(
              values: const [SkillType.listening, SkillType.speaking, SkillType.writing],
              labels: const ['Nghe', 'Nói', 'Viết'],
              selected: _type,
              onChanged: (v) => setState(() { _type = v; }),
            ),
            const SizedBox(height: AppSizes.paddingLg),

            // Dynamic fields
            _buildTypeFields(),
            const SizedBox(height: AppSizes.paddingLg),

            // Grading method
            const Text('Phương thức chấm điểm', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppSizes.paddingXs),
            _GradingSelector(selected: _grading, onChanged: (v) => setState(() => _grading = v)),
            const SizedBox(height: AppSizes.paddingLg),

            // Required switch
            Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Bài tập bắt buộc', style: AppTextStyles.labelMedium),
                    Text('Học viên phải vượt qua để hoàn thành ngày', style: AppTextStyles.labelSmall),
                  ],
                )),
                Switch(
                  value: _required,
                  onChanged: (v) => setState(() => _required = v),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingLg),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                  elevation: 0,
                ),
                child: const Text('Thêm vào ngày', style: AppTextStyles.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFields() {
    if (_type == SkillType.listening) {
      return _McqFields(
        options: _options,
        correctIndex: _correctIndex,
        onCorrectChanged: (i) => setState(() => _correctIndex = i),
        onOptionAdd: _addOption,
      );
    }
    if (_type == SkillType.writing) {
      return TextField(
        controller: _promptCtrl,
        maxLines: 3,
        decoration: _fieldDeco('Đề bài / Yêu cầu bài viết...'),
        style: AppTextStyles.bodyMedium,
      );
    }
    return TextField(
      controller: _promptCtrl,
      maxLines: 3,
      decoration: _fieldDeco('Kịch bản / Câu mẫu (tuỳ chọn)...'),
      style: AppTextStyles.bodyMedium,
    );
  }

  void _addOption() {
    if (_options.length >= 6) return;
    setState(() => _options.add(TextEditingController()));
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    final config = <String, dynamic>{};
    if (_type == SkillType.listening) {
      config['options'] = _options.map((c) => c.text.trim()).toList();
      config['correctIndex'] = _correctIndex;
    } else {
      config['prompt'] = _promptCtrl.text.trim();
    }
    Navigator.pop(
      context,
      RoadmapTaskDraft(
        title: title,
        type: _type,
        grading: _grading,
        required: _required,
        config: config,
      ),
    );
  }

  InputDecoration _fieldDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.labelSmall,
        filled: true,
        fillColor: AppColors.bgMuted,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: AppSizes.paddingMd),
      );
}

// ─── MCQ fields ───────────────────────────────────────────────────────────────

class _McqFields extends StatelessWidget {
  final List<TextEditingController> options;
  final int correctIndex;
  final ValueChanged<int> onCorrectChanged;
  final VoidCallback onOptionAdd;

  const _McqFields({
    required this.options,
    required this.correctIndex,
    required this.onCorrectChanged,
    required this.onOptionAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...options.asMap().entries.map((e) {
          final i = e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => onCorrectChanged(i),
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == correctIndex ? AppColors.primary : AppColors.background,
                      border: Border.all(color: i == correctIndex ? AppColors.primary : AppColors.stroke),
                    ),
                    child: i == correctIndex
                        ? const Icon(Icons.check, size: 16, color: AppColors.background)
                        : Center(child: Text(String.fromCharCode(65 + i), style: AppTextStyles.labelSmall)),
                  ),
                ),
                const SizedBox(width: AppSizes.paddingSm),
                Expanded(
                  child: TextField(
                    controller: e.value,
                    decoration: InputDecoration(
                      hintText: 'Đáp án ${String.fromCharCode(65 + i)}',
                      hintStyle: AppTextStyles.labelSmall,
                      filled: true, fillColor: AppColors.bgMuted,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSm), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMd, vertical: 10),
                      isDense: true,
                    ),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
        if (options.length < 6)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onOptionAdd,
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Thêm đáp án'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary600, padding: EdgeInsets.zero),
            ),
          ),
      ],
    );
  }
}

// ─── Segmented Row ─────────────────────────────────────────────────────────────

class _SegmentedRow<T> extends StatelessWidget {
  final List<T> values;
  final List<String> labels;
  final T selected;
  final ValueChanged<T> onChanged;

  const _SegmentedRow({required this.values, required this.labels, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: values.asMap().entries.map((e) {
        final isSelected = e.value == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(e.value),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.bgMuted,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(e.key == 0 ? AppSizes.radiusMd : 0),
                  right: Radius.circular(e.key == values.length - 1 ? AppSizes.radiusMd : 0),
                ),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.stroke),
              ),
              child: Text(labels[e.key],
                textAlign: TextAlign.center,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? AppColors.background : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Grading Selector ─────────────────────────────────────────────────────────

class _GradingSelector extends StatelessWidget {
  final GradingMethod selected;
  final ValueChanged<GradingMethod> onChanged;

  const _GradingSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GradingOption(GradingMethod.ai, '🤖 AI chấm', AppColors.purple500, AppColors.purple50, selected, onChanged),
        const SizedBox(width: AppSizes.paddingXs),
        _GradingOption(GradingMethod.teacher, '👨‍🏫 GV chấm', AppColors.orange, const Color(0xFFFFFAE7), selected, onChanged),
        const SizedBox(width: AppSizes.paddingXs),
        _GradingOption(GradingMethod.auto, '⚙️ Tự động', AppColors.textSecondary, AppColors.bgMuted, selected, onChanged),
      ],
    );
  }
}

class _GradingOption extends StatelessWidget {
  final GradingMethod method;
  final String label;
  final Color accent;
  final Color bg;
  final GradingMethod selected;
  final ValueChanged<GradingMethod> onChanged;

  const _GradingOption(this.method, this.label, this.accent, this.bg, this.selected, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selected;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(method),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? bg : AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: isSelected ? accent : AppColors.stroke, width: isSelected ? 1.5 : 1),
            boxShadow: isSelected && method == GradingMethod.ai
                ? [BoxShadow(color: AppColors.purple500.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          child: Text(label, textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? accent : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
