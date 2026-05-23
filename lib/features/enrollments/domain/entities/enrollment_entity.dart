import 'package:equatable/equatable.dart';

class EnrollmentEntity extends Equatable {
  final String id;
  final String userId;
  final String journeyId;
  final int currentDay;
  final int streak;
  final int freezeTokensLeft;
  final String? lastCompletedDate;
  final DateTime? completedAt;
  final String journeyTitle;
  final int journeyTotalDays;

  const EnrollmentEntity({
    required this.id,
    required this.userId,
    required this.journeyId,
    required this.currentDay,
    required this.streak,
    required this.freezeTokensLeft,
    this.lastCompletedDate,
    this.completedAt,
    required this.journeyTitle,
    required this.journeyTotalDays,
  });

  @override
  List<Object?> get props => [id, userId, journeyId, currentDay, streak];
}
