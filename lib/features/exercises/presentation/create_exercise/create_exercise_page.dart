import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/exercise_template_entity.dart';
import 'bloc/create_exercise_bloc.dart';
import 'bloc/create_exercise_event.dart';
import 'bloc/create_exercise_state.dart';

class CreateExercisePage extends StatelessWidget {
  final ExerciseTemplateEntity? prefill;

  const CreateExercisePage({super.key, this.prefill});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateExerciseBloc(datasource: sl())
        ..add(CreateExerciseInitialized(prefill: prefill)),
      child: const _CreateExerciseContent(),
    );
  }
}

class _CreateExerciseContent extends StatefulWidget {
  const _CreateExerciseContent();

  @override
  State<_CreateExerciseContent> createState() => _CreateExerciseContentState();
}

class _CreateExerciseContentState extends State<_CreateExerciseContent> {
  final _titleCtrl = TextEditingController();
  final _questionCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _questionCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<CreateExerciseBloc>().add(CreateExerciseSubmitted(
          title: _titleCtrl.text,
          question: _questionCtrl.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateExerciseBloc, CreateExerciseState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CreateExerciseStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã tạo bài tập thành công!')),
          );
          Navigator.pop(context, true);
        } else if (state.status == CreateExerciseStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Tạo bài tập thất bại'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Tạo bài tập', style: AppTextStyles.titleLarge),
            actions: [
              if (state.status == CreateExerciseStatus.submitting)
                const Padding(
                  padding: EdgeInsets.all(AppSizes.paddingMd),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () => _submit(context),
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TypeSelector(type: state.type),
                const SizedBox(height: AppSizes.paddingLg),
                _TitleField(controller: _titleCtrl),
                const SizedBox(height: AppSizes.paddingMd),
                _QuestionField(controller: _questionCtrl),
                const SizedBox(height: AppSizes.paddingLg),
                _TypeSpecificForm(state: state),
                const SizedBox(height: AppSizes.xxxl),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Type Selector ──────────────────────────────────────────────────────────

class _TypeSelector extends StatelessWidget {
  final String type;
  const _TypeSelector({required this.type});

  static const _types = [
    ('multiple_choice', 'Trắc nghiệm', Icons.check_circle_outline),
    ('fill_blank', 'Điền từ', Icons.text_fields_outlined),
    ('arrange', 'Sắp xếp', Icons.swap_horiz_outlined),
    ('recording', 'Ghi âm', Icons.mic_outlined),
    ('essay', 'Tự luận', Icons.article_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Loại bài tập', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSizes.paddingSm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _types.map((t) {
              final isSelected = type == t.$1;
              return Padding(
                padding: const EdgeInsets.only(right: AppSizes.paddingXs),
                child: ChoiceChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(t.$3,
                          size: 14,
                          color: isSelected
                              ? AppColors.background
                              : AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(t.$2),
                    ],
                  ),
                  onSelected: (_) => context
                      .read<CreateExerciseBloc>()
                      .add(CreateExerciseTypeChanged(t.$1)),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                  ),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Title & Question Fields ─────────────────────────────────────────────────

class _TitleField extends StatelessWidget {
  final TextEditingController controller;
  const _TitleField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Tiêu đề',
      child: TextField(
        controller: controller,
        decoration: _inputDecoration('VD: Từ vựng chủ đề môi trường'),
        style: AppTextStyles.bodyMedium,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class _QuestionField extends StatelessWidget {
  final TextEditingController controller;
  const _QuestionField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Câu hỏi / Đề bài',
      child: TextField(
        controller: controller,
        decoration: _inputDecoration('Nhập nội dung câu hỏi…'),
        maxLines: 3,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

// ─── Type-Specific Form ──────────────────────────────────────────────────────

class _TypeSpecificForm extends StatelessWidget {
  final CreateExerciseState state;
  const _TypeSpecificForm({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.type) {
      'multiple_choice' => _McqForm(options: state.options, correctIndex: state.correctIndex),
      'fill_blank' => _FillBlankForm(template: state.fillTemplate, answer: state.fillAnswer),
      'arrange' => _ArrangeForm(words: state.arrangeWords),
      'recording' => _RecordingForm(prompt: state.recordingPrompt),
      'essay' => _EssayForm(prompt: state.essayPrompt),
      _ => const SizedBox.shrink(),
    };
  }
}

// ─── MCQ Form ────────────────────────────────────────────────────────────────

class _McqForm extends StatelessWidget {
  final List<String> options;
  final int correctIndex;
  const _McqForm({required this.options, required this.correctIndex});

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Các lựa chọn',
      child: Column(
        children: [
          ...List.generate(options.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
              child: _McqOption(
                index: i,
                value: options[i],
                isCorrect: i == correctIndex,
                onChanged: (v) => context
                    .read<CreateExerciseBloc>()
                    .add(CreateExerciseOptionChanged(i, v)),
                onSetCorrect: () => context
                    .read<CreateExerciseBloc>()
                    .add(CreateExerciseCorrectIndexChanged(i)),
              ),
            );
          }),
          if (options.length < 6)
            TextButton.icon(
              onPressed: () => context
                  .read<CreateExerciseBloc>()
                  .add(const CreateExerciseOptionAdded()),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Thêm lựa chọn'),
              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _McqOption extends StatefulWidget {
  final int index;
  final String value;
  final bool isCorrect;
  final ValueChanged<String> onChanged;
  final VoidCallback onSetCorrect;

  const _McqOption({
    required this.index,
    required this.value,
    required this.isCorrect,
    required this.onChanged,
    required this.onSetCorrect,
  });

  @override
  State<_McqOption> createState() => _McqOptionState();
}

class _McqOptionState extends State<_McqOption> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = String.fromCharCode(65 + widget.index);
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onSetCorrect,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isCorrect
                  ? AppColors.success
                  : AppColors.surface,
              border: Border.all(
                color: widget.isCorrect
                    ? AppColors.success
                    : AppColors.divider,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.isCorrect
                      ? AppColors.background
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.paddingSm),
        Expanded(
          child: TextField(
            controller: _ctrl,
            onChanged: widget.onChanged,
            decoration: _inputDecoration('Lựa chọn $label'),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

// ─── Fill Blank Form ─────────────────────────────────────────────────────────

class _FillBlankForm extends StatefulWidget {
  final String template;
  final String answer;
  const _FillBlankForm({required this.template, required this.answer});

  @override
  State<_FillBlankForm> createState() => _FillBlankFormState();
}

class _FillBlankFormState extends State<_FillBlankForm> {
  late final TextEditingController _templateCtrl;
  late final TextEditingController _answerCtrl;

  @override
  void initState() {
    super.initState();
    _templateCtrl = TextEditingController(text: widget.template);
    _answerCtrl = TextEditingController(text: widget.answer);
  }

  @override
  void dispose() {
    _templateCtrl.dispose();
    _answerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FormField(
          label: 'Câu có chỗ trống (dùng ___ để đánh dấu)',
          child: TextField(
            controller: _templateCtrl,
            onChanged: (v) => context
                .read<CreateExerciseBloc>()
                .add(CreateExerciseFillTemplateChanged(v)),
            decoration: _inputDecoration('VD: The cat ___ on the mat'),
            maxLines: 2,
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: AppSizes.paddingMd),
        _FormField(
          label: 'Đáp án',
          child: TextField(
            controller: _answerCtrl,
            onChanged: (v) => context
                .read<CreateExerciseBloc>()
                .add(CreateExerciseFillAnswerChanged(v)),
            decoration: _inputDecoration('VD: sat'),
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}

// ─── Arrange Form ─────────────────────────────────────────────────────────────

class _ArrangeForm extends StatefulWidget {
  final List<String> words;
  const _ArrangeForm({required this.words});

  @override
  State<_ArrangeForm> createState() => _ArrangeFormState();
}

class _ArrangeFormState extends State<_ArrangeForm> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.words.join(' / '));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Các từ cần sắp xếp (phân cách bằng /)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _ctrl,
            onChanged: (v) {
              final words = v.split('/').map((w) => w.trim()).where((w) => w.isNotEmpty).toList();
              context.read<CreateExerciseBloc>().add(CreateExerciseArrangeWordsChanged(words));
            },
            decoration: _inputDecoration('VD: I / am / a / student'),
            maxLines: 2,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSizes.paddingXs),
          Text(
            'Thứ tự nhập vào là thứ tự đúng của câu trả lời',
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}

// ─── Recording Form ───────────────────────────────────────────────────────────

class _RecordingForm extends StatefulWidget {
  final String prompt;
  const _RecordingForm({required this.prompt});

  @override
  State<_RecordingForm> createState() => _RecordingFormState();
}

class _RecordingFormState extends State<_RecordingForm> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.prompt);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Nội dung cần đọc / chủ đề cần nói',
      child: TextField(
        controller: _ctrl,
        onChanged: (v) => context
            .read<CreateExerciseBloc>()
            .add(CreateExerciseRecordingPromptChanged(v)),
        decoration: _inputDecoration('VD: Đọc đoạn văn sau với tốc độ tự nhiên…'),
        maxLines: 4,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

// ─── Essay Form ───────────────────────────────────────────────────────────────

class _EssayForm extends StatefulWidget {
  final String prompt;
  const _EssayForm({required this.prompt});

  @override
  State<_EssayForm> createState() => _EssayFormState();
}

class _EssayFormState extends State<_EssayForm> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.prompt);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormField(
      label: 'Yêu cầu bài viết',
      child: TextField(
        controller: _ctrl,
        onChanged: (v) => context
            .read<CreateExerciseBloc>()
            .add(CreateExerciseEssayPromptChanged(v)),
        decoration: _inputDecoration('VD: Viết đoạn văn 100–150 từ về chủ đề môi trường…'),
        maxLines: 5,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

// ─── Shared helpers ──────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSizes.paddingXs),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.labelSmall,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMd,
        vertical: AppSizes.paddingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
