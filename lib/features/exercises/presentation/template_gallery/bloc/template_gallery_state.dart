import 'package:equatable/equatable.dart';

import '../../../domain/entities/exercise_template_entity.dart';

enum TemplateGalleryStatus { initial, loading, success, failure }

class TemplateGalleryState extends Equatable {
  final TemplateGalleryStatus status;
  final List<ExerciseTemplateEntity> templates;
  final String? selectedCategory;
  final String? errorMessage;

  const TemplateGalleryState({
    this.status = TemplateGalleryStatus.initial,
    this.templates = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  List<ExerciseTemplateEntity> get filtered => selectedCategory == null
      ? templates
      : templates.where((t) => t.templateCategory == selectedCategory).toList();

  TemplateGalleryState copyWith({
    TemplateGalleryStatus? status,
    List<ExerciseTemplateEntity>? templates,
    String? selectedCategory,
    bool clearCategory = false,
    String? errorMessage,
  }) =>
      TemplateGalleryState(
        status: status ?? this.status,
        templates: templates ?? this.templates,
        selectedCategory:
            clearCategory ? null : (selectedCategory ?? this.selectedCategory),
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, templates, selectedCategory, errorMessage];
}
