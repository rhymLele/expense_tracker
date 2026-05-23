import '../../domain/entities/exercise_entity.dart';

class ExerciseModel extends ExerciseEntity {
  const ExerciseModel({
    required super.id,
    required super.teacherId,
    required super.type,
    required super.title,
    super.description,
    required super.config,
    required super.createdAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        id: json['id'] as String,
        teacherId: json['teacherId'] as String,
        type: json['type'] as String? ?? 'ESSAY',
        title: json['title'] as String? ?? '',
        description: json['description'] as String?,
        config: json['config'] as Map<String, dynamic>? ?? {},
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
