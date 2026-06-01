import 'package:equatable/equatable.dart';

class ExerciseTemplateEntity extends Equatable {
  final String id;
  final String type;
  final String question;
  final Map<String, dynamic> config;
  final Map<String, dynamic>? answerKey;
  final String? templateCategory;

  const ExerciseTemplateEntity({
    required this.id,
    required this.type,
    required this.question,
    required this.config,
    this.answerKey,
    this.templateCategory,
  });

  String get categoryLabel {
    switch (templateCategory) {
      case 'vocabulary':
        return 'Từ vựng';
      case 'grammar':
        return 'Ngữ pháp';
      case 'speaking':
        return 'Luyện nói';
      case 'ielts_speaking':
        return 'IELTS Speaking';
      case 'writing':
        return 'Viết';
      default:
        return templateCategory ?? 'Khác';
    }
  }

  @override
  List<Object?> get props => [id, type, templateCategory];
}
