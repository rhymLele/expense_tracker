import 'package:equatable/equatable.dart';

class SubmissionEntity extends Equatable {
  final String id;
  final String enrollmentId;
  final String dayTaskId;
  final Map<String, dynamic> answer;
  final double? score;
  final String? feedback;
  final String? gradedBy;
  final DateTime? gradedAt;
  final DateTime createdAt;

  const SubmissionEntity({
    required this.id,
    required this.enrollmentId,
    required this.dayTaskId,
    required this.answer,
    this.score,
    this.feedback,
    this.gradedBy,
    this.gradedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, enrollmentId, dayTaskId, score, createdAt];
}
