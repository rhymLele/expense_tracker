import '../../../../../core/base/base_state.dart';
import '../../../domain/entities/exercise_template_entity.dart';

class TemplateGalleryState extends BaseState<TemplateGalleryState> {
  final List<ExerciseTemplateEntity> templates;
  final String? selectedCategory;

  const TemplateGalleryState({
    super.status,
    super.error,
    this.templates = const [],
    this.selectedCategory,
  });

  List<ExerciseTemplateEntity> get filtered => selectedCategory == null
      ? templates
      : templates.where((t) => t.templateCategory == selectedCategory).toList();

  TemplateGalleryState copyWith({
    ViewStatus? status,
    List<ExerciseTemplateEntity>? templates,
    String? selectedCategory,
    bool clearCategory = false,
    String? error,
  }) =>
      TemplateGalleryState(
        status: status ?? this.status,
        templates: templates ?? this.templates,
        selectedCategory:
            clearCategory ? null : (selectedCategory ?? this.selectedCategory),
        error: error,
      );

  @override
  TemplateGalleryState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [status, error, templates, selectedCategory];
}
