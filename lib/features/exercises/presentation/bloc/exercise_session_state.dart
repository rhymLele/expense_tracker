import 'package:equatable/equatable.dart';

import '../../../enrollments/domain/entities/today_tasks_entity.dart';
import '../../../journeys/domain/entities/day_task_entity.dart';
import '../../../submissions/domain/entities/submission_entity.dart';

enum ExerciseSessionStatus { loading, ready, submitting, feedback, done, error }

class ExerciseSessionState extends Equatable {
  final ExerciseSessionStatus status;
  final TodayTasksEntity? todayTasks;
  final int currentTaskIndex;
  final Map<String, SubmissionEntity> submissions;
  final SubmissionEntity? lastSubmission;
  final String? errorMessage;

  const ExerciseSessionState({
    this.status = ExerciseSessionStatus.loading,
    this.todayTasks,
    this.currentTaskIndex = 0,
    this.submissions = const {},
    this.lastSubmission,
    this.errorMessage,
  });

  List<DayTaskEntity> get tasks => todayTasks?.day.tasks ?? [];
  int get totalTasks => tasks.length;
  DayTaskEntity? get currentTask =>
      currentTaskIndex < tasks.length ? tasks[currentTaskIndex] : null;

  bool get isLastTask => currentTaskIndex >= tasks.length - 1;
  int get completedCount => submissions.length;

  ExerciseSessionState copyWith({
    ExerciseSessionStatus? status,
    TodayTasksEntity? todayTasks,
    int? currentTaskIndex,
    Map<String, SubmissionEntity>? submissions,
    SubmissionEntity? lastSubmission,
    String? errorMessage,
  }) =>
      ExerciseSessionState(
        status: status ?? this.status,
        todayTasks: todayTasks ?? this.todayTasks,
        currentTaskIndex: currentTaskIndex ?? this.currentTaskIndex,
        submissions: submissions ?? this.submissions,
        lastSubmission: lastSubmission,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        todayTasks,
        currentTaskIndex,
        submissions,
        lastSubmission,
        errorMessage,
      ];
}
