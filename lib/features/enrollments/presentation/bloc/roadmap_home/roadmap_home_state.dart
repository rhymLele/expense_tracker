import 'package:equatable/equatable.dart';
import '../../../domain/entities/enrollment_entity.dart';

enum RoadmapHomeStatus { initial, loading, success, failure }

class RoadmapHomeState extends Equatable {
  final RoadmapHomeStatus status;
  final EnrollmentEntity? active;
  final List<EnrollmentEntity> queue; // queued enrollments (status == 'queued')
  final Set<String> completedTaskIds; // local toggle state
  final bool isDayCompleted; // true when all tasks toggled
  final String? errorMessage;

  const RoadmapHomeState({
    this.status = RoadmapHomeStatus.initial,
    this.active,
    this.queue = const [],
    this.completedTaskIds = const {},
    this.isDayCompleted = false,
    this.errorMessage,
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
    RoadmapHomeStatus? status,
    EnrollmentEntity? active,
    List<EnrollmentEntity>? queue,
    Set<String>? completedTaskIds,
    bool? isDayCompleted,
    String? errorMessage,
  }) =>
      RoadmapHomeState(
        status: status ?? this.status,
        active: active ?? this.active,
        queue: queue ?? this.queue,
        completedTaskIds: completedTaskIds ?? this.completedTaskIds,
        isDayCompleted: isDayCompleted ?? this.isDayCompleted,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, active, queue, completedTaskIds, isDayCompleted, errorMessage];
}
