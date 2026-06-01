import 'package:equatable/equatable.dart';
import 'today_task_entity.dart';

class EnrollmentEntity extends Equatable {
  final String id;
  final String userId;
  final String roadmapId;
  final int currentDay; // 1-based
  final int streak;
  final String? lastCompletedDate;
  final DateTime? completedAt;
  final String journeyTitle;
  final int journeyTotalDays;
  final String status; // active | queued | completed | cancelled
  // Populated from getActive — tasks for today (roadmap.days[currentDayIndex])
  final List<TodayTaskEntity> todayTasks;
  // Titles of each day in the path (populated from roadmap.days)
  final List<String> dayTitles;

  const EnrollmentEntity({
    required this.id,
    required this.userId,
    required this.roadmapId,
    required this.currentDay,
    required this.streak,
    this.lastCompletedDate,
    this.completedAt,
    required this.journeyTitle,
    required this.journeyTotalDays,
    this.status = 'active',
    this.todayTasks = const [],
    this.dayTitles = const [],
  });

  String get journeyId => roadmapId;
  int get currentDayIndex => currentDay - 1;
  bool get isActive => status == 'active' && completedAt == null;
  bool get isQueued => status == 'queued';

  @override
  List<Object?> get props => [id, userId, roadmapId, currentDay, streak, status];
}
