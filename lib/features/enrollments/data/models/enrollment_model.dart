import '../../../journeys/data/models/journey_day_model.dart';
import '../../domain/entities/enrollment_entity.dart';
import '../../domain/entities/today_tasks_entity.dart';

class EnrollmentModel extends EnrollmentEntity {
  const EnrollmentModel({
    required super.id,
    required super.userId,
    required super.journeyId,
    required super.currentDay,
    required super.streak,
    required super.freezeTokensLeft,
    super.lastCompletedDate,
    super.completedAt,
    required super.journeyTitle,
    required super.journeyTotalDays,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    final journey = json['journey'] as Map<String, dynamic>? ?? {};
    return EnrollmentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      journeyId: json['journeyId'] as String,
      currentDay: json['currentDay'] as int? ?? 1,
      streak: json['streak'] as int? ?? 0,
      freezeTokensLeft: json['freezeTokensLeft'] as int? ?? 0,
      lastCompletedDate: json['lastCompletedDate'] as String?,
      completedAt:
          json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      journeyTitle: journey['title'] as String? ?? '',
      journeyTotalDays: journey['totalDays'] as int? ?? 0,
    );
  }
}

class TodayTasksModel extends TodayTasksEntity {
  const TodayTasksModel({
    required super.currentDay,
    required super.day,
    required super.submittedTaskIds,
  });

  factory TodayTasksModel.fromJson(Map<String, dynamic> json) {
    final rawIds = json['submittedTaskIds'] as List? ?? [];
    return TodayTasksModel(
      currentDay: json['currentDay'] as int? ?? 1,
      day: JourneyDayModel.fromJson(json['day'] as Map<String, dynamic>),
      submittedTaskIds: rawIds.cast<String>(),
    );
  }
}
