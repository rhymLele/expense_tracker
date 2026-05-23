import '../../domain/entities/submission_entity.dart';

class SubmissionModel extends SubmissionEntity {
  const SubmissionModel({
    required super.id,
    required super.enrollmentId,
    required super.dayTaskId,
    required super.answer,
    super.score,
    super.feedback,
    super.gradedBy,
    super.gradedAt,
    required super.createdAt,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) => SubmissionModel(
        id: json['id'] as String,
        enrollmentId: json['enrollmentId'] as String,
        dayTaskId: json['dayTaskId'] as String,
        answer: json['answer'] as Map<String, dynamic>? ?? {},
        score: (json['score'] as num?)?.toDouble(),
        feedback: json['feedback'] as String?,
        gradedBy: json['gradedBy'] as String?,
        gradedAt: json['gradedAt'] != null ? DateTime.parse(json['gradedAt'] as String) : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
