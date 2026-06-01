import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../enrollments/domain/usecases/get_today_tasks_usecase.dart';
import '../../../submissions/domain/usecases/submit_answer_usecase.dart';
import 'exercise_session_event.dart';
import 'exercise_session_state.dart';

class ExerciseSessionBloc
    extends Bloc<ExerciseSessionEvent, ExerciseSessionState> {
  final GetTodayTasksUseCase _getTodayTasks;
  final SubmitAnswerUseCase _submitAnswer;
  late String _enrollmentId;

  ExerciseSessionBloc({
    required GetTodayTasksUseCase getTodayTasks,
    required SubmitAnswerUseCase submitAnswer,
  })  : _getTodayTasks = getTodayTasks,
        _submitAnswer = submitAnswer,
        super(const ExerciseSessionState()) {
    on<ExerciseSessionStarted>(_onStarted);
    on<ExerciseAnswerSubmitted>(_onAnswerSubmitted);
    on<ExerciseFeedbackAcknowledged>(_onFeedbackAcknowledged);
  }

  Future<void> _onStarted(
    ExerciseSessionStarted event,
    Emitter<ExerciseSessionState> emit,
  ) async {
    _enrollmentId = event.enrollmentId;
    emit(state.copyWith(status: ExerciseSessionStatus.loading));
    final result = await _getTodayTasks(_enrollmentId);
    result.fold(
      (f) => emit(state.copyWith(
        status: ExerciseSessionStatus.error,
        errorMessage: f.message,
      )),
      (tasks) {
        // Skip tasks that were already submitted in a previous session
        final firstUnsubmitted = tasks.day.tasks.indexWhere(
          (t) => !tasks.submittedTaskIds.contains(t.id),
        );
        emit(state.copyWith(
          status: tasks.day.tasks.isEmpty
              ? ExerciseSessionStatus.done
              : ExerciseSessionStatus.ready,
          todayTasks: tasks,
          currentTaskIndex: firstUnsubmitted < 0 ? 0 : firstUnsubmitted,
        ));
      },
    );
  }

  Future<void> _onAnswerSubmitted(
    ExerciseAnswerSubmitted event,
    Emitter<ExerciseSessionState> emit,
  ) async {
    final task = state.currentTask;
    if (task == null) return;
    emit(state.copyWith(status: ExerciseSessionStatus.submitting));
    final result = await _submitAnswer(
      enrollmentId: _enrollmentId,
      dayTaskId: task.id,
      answer: event.answer,
    );
    result.fold(
      (f) => emit(state.copyWith(
        status: ExerciseSessionStatus.ready,
        errorMessage: f.message,
      )),
      (submission) {
        final updated = Map<String, dynamic>.from(state.submissions)
          ..[task.id] = submission;
        emit(state.copyWith(
          status: ExerciseSessionStatus.feedback,
          submissions: Map.from(updated),
          lastSubmission: submission,
        ));
      },
    );
  }

  void _onFeedbackAcknowledged(
    ExerciseFeedbackAcknowledged event,
    Emitter<ExerciseSessionState> emit,
  ) {
    if (state.isLastTask) {
      emit(state.copyWith(status: ExerciseSessionStatus.done));
    } else {
      emit(state.copyWith(
        status: ExerciseSessionStatus.ready,
        currentTaskIndex: state.currentTaskIndex + 1,
      ));
    }
  }
}
