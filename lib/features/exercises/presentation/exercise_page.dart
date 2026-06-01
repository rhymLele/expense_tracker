import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/base_loading.dart';
import '../../enrollments/domain/entities/enrollment_entity.dart';
import 'bloc/exercise_session_bloc.dart';
import 'bloc/exercise_session_event.dart';
import 'bloc/exercise_session_state.dart';
import 'widgets/fill_blank_exercise_widget.dart';
import 'widgets/mcq_exercise_widget.dart';
import 'widgets/open_exercise_widget.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    final enrollment =
        ModalRoute.of(context)!.settings.arguments as EnrollmentEntity;
    return BlocProvider(
      create: (_) => sl<ExerciseSessionBloc>()
        ..add(ExerciseSessionStarted(enrollment.id)),
      child: _ExerciseContent(enrollment: enrollment),
    );
  }
}

class _ExerciseContent extends StatelessWidget {
  final EnrollmentEntity enrollment;
  const _ExerciseContent({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExerciseSessionBloc, ExerciseSessionState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) {
        if (state.status == ExerciseSessionStatus.done) {
          _showCompletionDialog(ctx, enrollment);
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(ctx, state),
          body: _buildBody(ctx, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, ExerciseSessionState state) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: state.status == ExerciseSessionStatus.loading
          ? null
          : Text(
              '${state.currentTaskIndex + 1} / ${state.totalTasks}',
              style: AppTextStyles.titleMedium,
            ),
      centerTitle: true,
      bottom: state.status != ExerciseSessionStatus.loading &&
              state.totalTasks > 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: state.totalTasks > 0
                    ? (state.currentTaskIndex + 1) / state.totalTasks
                    : 0,
                backgroundColor: AppColors.divider,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 3,
              ),
            )
          : null,
    );
  }

  Widget _buildBody(BuildContext context, ExerciseSessionState state) {
    switch (state.status) {
      case ExerciseSessionStatus.loading:
        return const Center(child: BaseLoading());

      case ExerciseSessionStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.textHint),
                const SizedBox(height: AppSizes.paddingMd),
                Text(
                  state.errorMessage ?? 'Không tải được bài tập',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.paddingLg),
                TextButton(
                  onPressed: () => context
                      .read<ExerciseSessionBloc>()
                      .add(ExerciseSessionStarted(enrollment.id)),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );

      case ExerciseSessionStatus.done:
        return const SizedBox.shrink();

      case ExerciseSessionStatus.feedback:
        return _FeedbackOverlay(
          state: state,
          onNext: () => context
              .read<ExerciseSessionBloc>()
              .add(const ExerciseFeedbackAcknowledged()),
        );

      case ExerciseSessionStatus.ready:
      case ExerciseSessionStatus.submitting:
        return _ExerciseBody(state: state);
    }
  }

  void _showCompletionDialog(
      BuildContext context, EnrollmentEntity enrollment) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSizes.paddingMd),
            Text(
              'Hoàn thành ngày ${enrollment.currentDay}!',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingXs),
            Text(
              'Tuyệt vời! Bạn đã hoàn thành tất cả bài tập hôm nay.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // close exercise page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              child: const Text('Xong'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exercise Body ─────────────────────────────────────────────────────────

class _ExerciseBody extends StatelessWidget {
  final ExerciseSessionState state;
  const _ExerciseBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final task = state.currentTask;
    final exercise = task?.exercise;

    if (task == null || exercise == null) {
      return const Center(child: Text('Không có bài tập'));
    }

    final isSubmitting = state.status == ExerciseSessionStatus.submitting;
    final config = exercise.config;

    Widget exerciseWidget;
    switch (exercise.type) {
      case 'mcq':
        final options = (config['options'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        exerciseWidget = McqExerciseWidget(
          question: exercise.title,
          options: options,
          enabled: !isSubmitting,
          onSubmit: (answer) => context
              .read<ExerciseSessionBloc>()
              .add(ExerciseAnswerSubmitted(answer)),
        );
      case 'fill_blank':
        exerciseWidget = FillBlankExerciseWidget(
          question: exercise.title,
          template: config['template']?.toString() ?? exercise.title,
          enabled: !isSubmitting,
          onSubmit: (answer) => context
              .read<ExerciseSessionBloc>()
              .add(ExerciseAnswerSubmitted(answer)),
        );
      case 'recording':
        exerciseWidget = OpenExerciseWidget(
          question: exercise.title,
          prompt: config['prompt']?.toString() ?? '',
          isRecording: true,
          enabled: !isSubmitting,
          onSubmit: (answer) => context
              .read<ExerciseSessionBloc>()
              .add(ExerciseAnswerSubmitted(answer)),
        );
      default: // essay
        exerciseWidget = OpenExerciseWidget(
          question: exercise.title,
          prompt: config['prompt']?.toString() ?? exercise.description ?? '',
          enabled: !isSubmitting,
          onSubmit: (answer) => context
              .read<ExerciseSessionBloc>()
              .add(ExerciseAnswerSubmitted(answer)),
        );
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ExerciseTypeChip(type: exercise.type),
              const SizedBox(height: AppSizes.paddingLg),
              exerciseWidget,
              const SizedBox(height: AppSizes.xxxl),
            ],
          ),
        ),
        if (isSubmitting)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33FFFFFF),
              child: Center(child: BaseLoading()),
            ),
          ),
      ],
    );
  }
}

class _ExerciseTypeChip extends StatelessWidget {
  final String type;
  const _ExerciseTypeChip({required this.type});

  static const _labels = {
    'mcq': ('Trắc nghiệm', Icons.check_box_outlined),
    'fill_blank': ('Điền từ', Icons.edit_outlined),
    'recording': ('Ghi âm', Icons.mic_outlined),
    'essay': ('Tự luận', Icons.article_outlined),
  };

  @override
  Widget build(BuildContext context) {
    final info = _labels[type] ?? ('Bài tập', Icons.quiz_outlined);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(info.$2, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          info.$1,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Feedback Overlay ──────────────────────────────────────────────────────

class _FeedbackOverlay extends StatelessWidget {
  final ExerciseSessionState state;
  final VoidCallback onNext;

  const _FeedbackOverlay({required this.state, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final submission = state.lastSubmission;
    if (submission == null) return const SizedBox.shrink();

    final isAutoGraded = submission.score != null;
    final isPassing = (submission.score ?? 0) > 0;

    final Color feedbackColor =
        isAutoGraded ? (isPassing ? AppColors.success : AppColors.error) : AppColors.warning;

    final String feedbackTitle = isAutoGraded
        ? (isPassing ? 'Chính xác!' : 'Chưa đúng rồi')
        : 'Đã nộp bài';

    final String feedbackSub = isAutoGraded
        ? (isPassing
            ? 'Làm tốt lắm! Tiếp tục phát huy.'
            : (submission.feedback ?? 'Xem lại kiến thức và thử lại nhé!'))
        : 'Giáo viên sẽ chấm điểm bài này.';

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: feedbackColor.withValues(alpha: 0.06),
            padding: const EdgeInsets.all(AppSizes.paddingXl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: feedbackColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    isAutoGraded
                        ? (isPassing ? Icons.check_rounded : Icons.close_rounded)
                        : Icons.schedule_rounded,
                    size: 44,
                    color: feedbackColor,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingLg),
                Text(
                  feedbackTitle,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: feedbackColor,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXs),
                Text(
                  feedbackSub,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isAutoGraded && submission.score != null) ...[
                  const SizedBox(height: AppSizes.paddingLg),
                  Text(
                    'Điểm: ${submission.score!.toStringAsFixed(1)}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: feedbackColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.paddingLg,
            AppSizes.paddingLg,
            AppSizes.paddingLg,
            AppSizes.paddingXl,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: feedbackColor,
                foregroundColor: AppColors.background,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
              ),
              child: Text(
                state.isLastTask ? 'Hoàn thành' : 'Tiếp theo',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
