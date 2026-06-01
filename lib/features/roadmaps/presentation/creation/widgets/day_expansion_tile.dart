import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/sizes.dart';
import '../../../../../core/constants/text_styles.dart';
import '../bloc/roadmap_creation_bloc.dart';
import '../bloc/roadmap_creation_event.dart';
import '../bloc/roadmap_creation_state.dart';

class DayExpansionTile extends StatefulWidget {
  final int dayIndex;
  final RoadmapDayDraft day;

  const DayExpansionTile({
    super.key,
    required this.dayIndex,
    required this.day,
  });

  @override
  State<DayExpansionTile> createState() => _DayExpansionTileState();
}

class _DayExpansionTileState extends State<DayExpansionTile> {
  final _titleCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = widget.day.title;
  }

  @override
  void didUpdateWidget(DayExpansionTile old) {
    super.didUpdateWidget(old);
    if (old.day.title != widget.day.title &&
        _titleCtrl.text != widget.day.title) {
      _titleCtrl.text = widget.day.title;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          _DayHeader(
            dayIndex: widget.dayIndex,
            titleCtrl: _titleCtrl,
            onTitleChanged: (v) => context
                .read<RoadmapCreationBloc>()
                .add(DayTitleChanged(widget.dayIndex, v)),
            canRemove: true,
            onRemove: () => context
                .read<RoadmapCreationBloc>()
                .add(RoadmapDayRemoved(widget.dayIndex)),
          ),
          // Tasks
          if (widget.day.tasks.isNotEmpty) ...[
            const Divider(height: 1, color: AppColors.strokeSoft),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Column(
                children: widget.day.tasks
                    .asMap()
                    .entries
                    .map((e) => _InlineTaskRow(
                          dayIndex: widget.dayIndex,
                          taskIndex: e.key,
                          task: e.value,
                        ))
                    .toList(),
              ),
            ),
          ],
          // Add task button
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: GestureDetector(
              onTap: () => context.read<RoadmapCreationBloc>().add(
                    TaskAddedToDay(
                      widget.dayIndex,
                      const RoadmapTaskDraft(),
                    ),
                  ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 15, color: AppColors.primary600),
                    SizedBox(width: 5),
                    Text(
                      'Thêm bài tập',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day header ───────────────────────────────────────────────────────────────

class _DayHeader extends StatelessWidget {
  final int dayIndex;
  final TextEditingController titleCtrl;
  final ValueChanged<String> onTitleChanged;
  final bool canRemove;
  final VoidCallback onRemove;

  const _DayHeader({
    required this.dayIndex,
    required this.titleCtrl,
    required this.onTitleChanged,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      child: Row(
        children: [
          // Day number badge
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'N${dayIndex + 1}',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary600,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title field
          Expanded(
            child: TextField(
              controller: titleCtrl,
              onChanged: onTitleChanged,
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Tiêu đề ngày...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // Remove button (only when > 1 day)
          if (canRemove)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.textHint),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: 'Xóa ngày',
            ),
        ],
      ),
    );
  }
}

// ─── Inline task row ──────────────────────────────────────────────────────────

class _InlineTaskRow extends StatefulWidget {
  final int dayIndex;
  final int taskIndex;
  final RoadmapTaskDraft task;

  const _InlineTaskRow({
    required this.dayIndex,
    required this.taskIndex,
    required this.task,
  });

  @override
  State<_InlineTaskRow> createState() => _InlineTaskRowState();
}

class _InlineTaskRowState extends State<_InlineTaskRow> {
  final _descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _descCtrl.text = widget.task.title;
  }

  @override
  void didUpdateWidget(_InlineTaskRow old) {
    super.didUpdateWidget(old);
    if (old.task.title != widget.task.title &&
        _descCtrl.text != widget.task.title) {
      _descCtrl.text = widget.task.title;
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Skill type dropdown
          _SkillDropdown(
            value: widget.task.type,
            onChanged: (t) => context.read<RoadmapCreationBloc>().add(
                  TaskTypeChanged(widget.dayIndex, widget.taskIndex, t),
                ),
          ),
          const SizedBox(width: 8),
          // Description field
          Expanded(
            child: TextField(
              controller: _descCtrl,
              onChanged: (v) => context.read<RoadmapCreationBloc>().add(
                    TaskDescriptionChanged(
                        widget.dayIndex, widget.taskIndex, v),
                  ),
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Mô tả bài tập...',
                hintStyle: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.bgPage,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 9),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.stroke),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.stroke),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusMd),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
                isDense: true,
              ),
            ),
          ),
          // Remove task
          IconButton(
            icon: const Icon(Icons.close,
                size: 16, color: AppColors.textHint),
            onPressed: () => context.read<RoadmapCreationBloc>().add(
                  TaskRemovedFromDay(
                      widget.dayIndex, widget.taskIndex),
                ),
            padding: EdgeInsets.zero,
            constraints:
                const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}

// ─── Skill type dropdown ──────────────────────────────────────────────────────

class _SkillDropdown extends StatelessWidget {
  final SkillType value;
  final ValueChanged<SkillType> onChanged;

  const _SkillDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border:
            Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SkillType>(
          value: value,
          isDense: true,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary600,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: AppColors.background,
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 14, color: AppColors.primary600),
          items: SkillType.values
              .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.label),
                  ))
              .toList(),
          onChanged: (t) {
            if (t != null) onChanged(t);
          },
        ),
      ),
    );
  }
}
