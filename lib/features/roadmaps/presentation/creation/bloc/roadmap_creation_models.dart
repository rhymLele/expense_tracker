import 'package:equatable/equatable.dart';

enum SkillType { listening, speaking, reading, writing, vocabulary, grammar }

extension SkillTypeLabel on SkillType {
  String get label => switch (this) {
        SkillType.listening  => 'Nghe',
        SkillType.speaking   => 'Nói',
        SkillType.reading    => 'Đọc',
        SkillType.writing    => 'Viết',
        SkillType.vocabulary => 'Từ vựng',
        SkillType.grammar    => 'Ngữ pháp',
      };
}

typedef TaskType = SkillType;

enum GradingMethod { ai, teacher, auto }

class RoadmapTaskDraft extends Equatable {
  final String title;
  final SkillType type;
  final GradingMethod grading;
  final bool required;
  final Map<String, dynamic> config;

  const RoadmapTaskDraft({
    this.title = '',
    this.type = SkillType.listening,
    this.grading = GradingMethod.auto,
    this.required = true,
    this.config = const {},
  });

  RoadmapTaskDraft copyWith({
    String? title,
    SkillType? type,
    GradingMethod? grading,
    bool? required,
    Map<String, dynamic>? config,
  }) =>
      RoadmapTaskDraft(
        title: title ?? this.title,
        type: type ?? this.type,
        grading: grading ?? this.grading,
        required: required ?? this.required,
        config: config ?? this.config,
      );

  @override
  List<Object?> get props => [title, type, grading, required];
}
