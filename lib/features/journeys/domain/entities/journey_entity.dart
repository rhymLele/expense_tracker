import 'package:equatable/equatable.dart';

class JourneyEntity extends Equatable {
  final String id;
  final String teacherId;
  final String title;
  final String? description;
  final String paceMode;
  final double passingScore;
  final bool allowResubmit;
  final int freezeTokens;
  final int totalDays;
  final DateTime? deadlineDate;
  final String? topicId;
  final DateTime createdAt;

  const JourneyEntity({
    required this.id,
    required this.teacherId,
    required this.title,
    this.description,
    required this.paceMode,
    required this.passingScore,
    required this.allowResubmit,
    required this.freezeTokens,
    required this.totalDays,
    this.deadlineDate,
    this.topicId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, teacherId, title, paceMode, totalDays, createdAt];
}
