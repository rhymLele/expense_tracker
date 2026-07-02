import '../../../../../core/base/base_state.dart';
import '../../../domain/entities/enrollment_entity.dart';

class RoadmapHomeState extends BaseState<RoadmapHomeState> {
  final EnrollmentEntity? active;
  final List<EnrollmentEntity> queue; // queued enrollments (status == 'queued')
  final Set<String> completedTaskIds; // local toggle state
  final bool isDayCompleted; // true when all tasks toggled

  const RoadmapHomeState({
    super.status,
    super.error,
    this.active,
    this.queue = const [],
    this.completedTaskIds = const {},
    this.isDayCompleted = false,
  });

  int get doneCount => completedTaskIds.length;
  int get totalCount => active?.todayTasks.length ?? 0;
  bool get allTasksDone => totalCount > 0 && doneCount >= totalCount;

  double get progressFraction {
    final total = active?.journeyTotalDays ?? 0;
    if (total == 0) return 0;
    return ((active?.currentDay ?? 0) / total).clamp(0.0, 1.0);
  }

  RoadmapHomeState copyWith({
    ViewStatus? status,
    EnrollmentEntity? active,
    List<EnrollmentEntity>? queue,
    Set<String>? completedTaskIds,
    bool? isDayCompleted,
    String? error,
  }) =>
      RoadmapHomeState(
        status: status ?? this.status,
        active: active ?? this.active,
        queue: queue ?? this.queue,
        completedTaskIds: completedTaskIds ?? this.completedTaskIds,
        isDayCompleted: isDayCompleted ?? this.isDayCompleted,
        error: error,
      );

  @override
  RoadmapHomeState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props =>
      [status, error, active, queue, completedTaskIds, isDayCompleted];
}
