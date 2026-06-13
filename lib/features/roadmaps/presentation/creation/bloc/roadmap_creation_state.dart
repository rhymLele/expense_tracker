import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import 'roadmap_creation_models.dart';

enum RoadmapCreationStatus { idle, saving, publishing, success, failure }

class RoadmapDayDraft extends Equatable {
  final String title;
  final List<RoadmapTaskDraft> tasks;

  const RoadmapDayDraft({this.title = '', this.tasks = const []});

  RoadmapDayDraft copyWith({String? title, List<RoadmapTaskDraft>? tasks}) =>
      RoadmapDayDraft(title: title ?? this.title, tasks: tasks ?? this.tasks);

  @override
  List<Object?> get props => [title, tasks];
}

class RoadmapCreationState extends Equatable {
  final RoadmapCreationStatus status;
  final String title;
  final String description;
  final int totalDays;
  final List<RoadmapDayDraft> days;
  final Color coverColor;
  final String? coverImagePath;
  final String? subject;
  final String level;
  final bool draftSaved;
  final String? errorMessage;
  final String? validationMessage;

  const RoadmapCreationState({
    this.status = RoadmapCreationStatus.idle,
    this.title = '',
    this.description = '',
    this.totalDays = 1,
    this.days = const [],
    this.coverColor = AppColors.primary,
    this.coverImagePath,
    this.subject,
    this.level = 'intermediate',
    this.draftSaved = false,
    this.errorMessage,
    this.validationMessage,
  });

  bool get isPublishable {
    if (title.trim().isEmpty) return false;
    if (days.isEmpty) return false;
    return days.first.tasks.any((t) => t.required);
  }

  String? get publishValidationMessage {
    if (title.trim().isEmpty) return 'Vui lòng nhập tên lộ trình';
    if (days.isEmpty || !days.first.tasks.any((t) => t.required)) {
      return 'Ngày 1 cần có ít nhất 1 bài tập';
    }
    return null;
  }

  int get totalTaskCount => days.fold(0, (s, d) => s + d.tasks.length);

  String get levelLabel => switch (level) {
        'beginner'     => 'Cơ bản',
        'intermediate' => 'Trung cấp',
        'advanced'     => 'Nâng cao',
        _              => 'Trung cấp',
      };

  RoadmapCreationState copyWith({
    RoadmapCreationStatus? status,
    String? title,
    String? description,
    int? totalDays,
    List<RoadmapDayDraft>? days,
    Color? coverColor,
    String? coverImagePath,
    String? subject,
    String? level,
    bool? draftSaved,
    String? errorMessage,
    String? validationMessage,
  }) =>
      RoadmapCreationState(
        status: status ?? this.status,
        title: title ?? this.title,
        description: description ?? this.description,
        totalDays: totalDays ?? this.totalDays,
        days: days ?? this.days,
        coverColor: coverColor ?? this.coverColor,
        coverImagePath: coverImagePath ?? this.coverImagePath,
        subject: subject ?? this.subject,
        level: level ?? this.level,
        draftSaved: draftSaved ?? this.draftSaved,
        errorMessage: errorMessage,
        validationMessage: validationMessage,
      );

  @override
  List<Object?> get props => [
        status, title, description, totalDays, days,
        coverColor, coverImagePath, subject, level,
        draftSaved, errorMessage, validationMessage,
      ];
}
