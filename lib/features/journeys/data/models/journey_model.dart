import '../../domain/entities/journey_entity.dart';

class JourneyModel extends JourneyEntity {
  const JourneyModel({
    required super.id,
    required super.teacherId,
    required super.title,
    super.description,
    required super.paceMode,
    required super.passingScore,
    required super.allowResubmit,
    required super.freezeTokens,
    required super.totalDays,
    super.deadlineDate,
    super.topicId,
    required super.createdAt,
  });

  factory JourneyModel.fromJson(Map<String, dynamic> json) => JourneyModel(
        id: json['id'] as String,
        teacherId: json['teacherId'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        paceMode: json['paceMode'] as String? ?? 'SELF_PACED',
        passingScore: (json['passingScore'] as num?)?.toDouble() ?? 70.0,
        allowResubmit: json['allowResubmit'] as bool? ?? true,
        freezeTokens: json['freezeTokens'] as int? ?? 0,
        totalDays: json['totalDays'] as int? ?? 0,
        deadlineDate:
            json['deadlineDate'] != null ? DateTime.parse(json['deadlineDate'] as String) : null,
        topicId: json['topicId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
