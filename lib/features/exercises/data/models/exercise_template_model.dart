import '../../domain/entities/exercise_template_entity.dart';

class ExerciseTemplateModel extends ExerciseTemplateEntity {
  const ExerciseTemplateModel({
    required super.id,
    required super.type,
    required super.question,
    required super.config,
    super.answerKey,
    super.templateCategory,
  });

  factory ExerciseTemplateModel.fromJson(Map<String, dynamic> json) =>
      ExerciseTemplateModel(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'multiple_choice',
        question: json['question'] as String? ?? '',
        config: json['config'] as Map<String, dynamic>? ?? {},
        answerKey: json['answerKey'] as Map<String, dynamic>?,
        templateCategory: json['templateCategory'] as String?,
      );
}
