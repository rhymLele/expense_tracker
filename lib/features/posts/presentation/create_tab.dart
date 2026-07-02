import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../lingua_thread/theme/lt_colors.dart';
import '../../../lingua_thread/theme/lt_typography.dart';
import '../../posts/presentation/bloc/create_post_cubit.dart';
import '../../posts/presentation/bloc/create_post_state.dart';

const _kLangs = ['English', 'Japanese', 'Korean', 'French', 'Spanish'];
const _kSkillTags = [
  '#writing', '#grammar', '#vocabulary', '#speaking',
  '#ielts', '#business', '#tips',
];
const _kCefr = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const _kDurations = ['1 week', '2 weeks', '30 days', '6 weeks', '3 months'];

class CreateTab extends StatelessWidget {
  const CreateTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreatePostCubit>(),
      child: const _CreateTabView(),
    );
  }
}

class _CreateTabView extends StatefulWidget {
  const _CreateTabView();

  @override
  State<_CreateTabView> createState() => _CreateTabViewState();
}

class _CreateTabViewState extends State<_CreateTabView> {
  final _contentCtrl = TextEditingController();
  final _threadTitleCtrl = TextEditingController();

  String? _selectedLang;
  final Set<String> _selectedTags = {};
  bool _isThread = false;
  String _threadLevel = 'B1';
  String _threadDuration = '30 days';

  @override
  void initState() {
    super.initState();
    _contentCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    _threadTitleCtrl.dispose();
    super.dispose();
  }

  bool get _canPublish =>
      _contentCtrl.text.trim().isNotEmpty && _selectedLang != null;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listener: (ctx, state) {
        if (state.isSuccess) Navigator.pop(ctx, true);
        if (state.isFailure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.error ?? 'Có lỗi xảy ra')),
          );
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: LtColors.bg,
          appBar: AppBar(
            backgroundColor: LtColors.bg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16,
            title: Text(
              'New Post',
              style: LtTypography.heading.copyWith(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  backgroundColor: LtColors.bgMuted,
                  foregroundColor: LtColors.textMuted,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: LtColors.divider),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('Draft', style: LtTypography.smallMed),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: (state.isLoading || !_canPublish)
                    ? null
                    : () => ctx
                        .read<CreatePostCubit>()
                        .submit(_contentCtrl.text),
                style: TextButton.styleFrom(
                  backgroundColor: LtColors.ink,
                  disabledBackgroundColor: LtColors.divider,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _isThread ? 'Publish Thread' : 'Publish',
                        style:
                            LtTypography.smallBold.copyWith(color: Colors.white),
                      ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Tag (required)
                Text('Language Tag *', style: LtTypography.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _kLangs.map((lang) {
                    final sel = _selectedLang == lang;
                    return _Chip(
                      label: lang,
                      selected: sel,
                      onTap: () => setState(
                          () => _selectedLang = sel ? null : lang),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Content textarea
                Container(
                  constraints: const BoxConstraints(minHeight: 180),
                  decoration: BoxDecoration(
                    border: Border.all(color: LtColors.divider),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: TextField(
                    controller: _contentCtrl,
                    autofocus: true,
                    maxLines: null,
                    style: LtTypography.body.copyWith(height: 1.7),
                    decoration: InputDecoration(
                      hintText:
                          "What's on your mind? Share a tip, question, resource, or insight…",
                      hintStyle: LtTypography.body.copyWith(
                          color: LtColors.textLight, height: 1.7),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Skill Tags (optional)
                Text('Skill Tags (optional)', style: LtTypography.label),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _kSkillTags.map((tag) {
                    final sel = _selectedTags.contains(tag);
                    return _Chip(
                      label: tag,
                      selected: sel,
                      fontSize: 12,
                      onTap: () => setState(() {
                        if (sel) { _selectedTags.remove(tag); }
                        else { _selectedTags.add(tag); }
                      }),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                const Divider(color: LtColors.divider, height: 1),

                // Add Learning Path toggle
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add Learning Path',
                                style: LtTypography.bodyBold),
                            const SizedBox(height: 2),
                            Text(
                              'Turn this post into a Thread',
                              style: LtTypography.caption
                                  .copyWith(color: LtColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isThread = !_isThread),
                        child: _Toggle(value: _isThread),
                      ),
                    ],
                  ),
                ),

                // Thread settings (conditional)
                if (_isThread) ...[
                  _ThreadSettings(
                    titleCtrl: _threadTitleCtrl,
                    level: _threadLevel,
                    duration: _threadDuration,
                    onLevelChanged: (v) =>
                        setState(() => _threadLevel = v),
                    onDurationChanged: (v) =>
                        setState(() => _threadDuration = v),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Shared chip button ──────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.fontSize = 13,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            EdgeInsets.symmetric(horizontal: fontSize == 12 ? 10 : 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? LtColors.ink : LtColors.bgMuted,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: selected ? LtColors.ink : LtColors.divider),
        ),
        child: Text(
          label,
          style: LtTypography.smallMed.copyWith(
            fontSize: fontSize,
            color: selected ? Colors.white : LtColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Toggle switch ───────────────────────────────────────────────────────────

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        color: value ? LtColors.ink : LtColors.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            left: value ? 23 : 3,
            top: 3,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Thread settings panel ───────────────────────────────────────────────────

class _ThreadSettings extends StatelessWidget {
  const _ThreadSettings({
    required this.titleCtrl,
    required this.level,
    required this.duration,
    required this.onLevelChanged,
    required this.onDurationChanged,
  });

  final TextEditingController titleCtrl;
  final String level;
  final String duration;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: LtColors.bgSubtle,
        border: Border.all(color: LtColors.divider),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🧵 Thread Settings', style: LtTypography.label),
          const SizedBox(height: 12),

          // Thread title
          Text('Thread Title *',
              style: LtTypography.caption
                  .copyWith(fontWeight: FontWeight.w600, color: LtColors.ink)),
          const SizedBox(height: 5),
          TextField(
            controller: titleCtrl,
            style: LtTypography.body,
            decoration: InputDecoration(
              hintText: 'e.g. IELTS Writing Task 2 Masterclass',
              hintStyle:
                  LtTypography.body.copyWith(color: LtColors.textLight),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: LtColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: LtColors.ink),
              ),
              filled: true,
              fillColor: LtColors.bg,
            ),
          ),
          const SizedBox(height: 12),

          // CEFR + Duration row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CEFR Level',
                        style: LtTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: LtColors.ink)),
                    const SizedBox(height: 5),
                    _SelectField<String>(
                      value: level,
                      items: _kCefr,
                      onChanged: onLevelChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Duration',
                        style: LtTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: LtColors.ink)),
                    const SizedBox(height: 5),
                    _SelectField<String>(
                      value: duration,
                      items: _kDurations,
                      onChanged: onDurationChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Add Nodes button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Text('⬡',
                  style: TextStyle(fontSize: 15, fontFamily: '')),
              label: const Text('Add Nodes (0)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: LtColors.ink,
                side: const BorderSide(color: LtColors.divider),
                backgroundColor: LtColors.bg,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                textStyle: LtTypography.smallBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Select dropdown ─────────────────────────────────────────────────────────

class _SelectField<T> extends StatelessWidget {
  const _SelectField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LtColors.bg,
        border: Border.all(color: LtColors.divider),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          style: LtTypography.body.copyWith(fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 18, color: LtColors.textMuted),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

