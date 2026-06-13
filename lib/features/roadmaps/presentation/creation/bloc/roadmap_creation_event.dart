import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'roadmap_creation_models.dart';

abstract class RoadmapCreationEvent extends Equatable {
  const RoadmapCreationEvent();
  @override
  List<Object?> get props => [];
}

class RoadmapInitialized extends RoadmapCreationEvent {
  const RoadmapInitialized();
}

class RoadmapTitleChanged extends RoadmapCreationEvent {
  final String title;
  const RoadmapTitleChanged(this.title);
  @override
  List<Object?> get props => [title];
}

class RoadmapDescriptionChanged extends RoadmapCreationEvent {
  final String description;
  const RoadmapDescriptionChanged(this.description);
  @override
  List<Object?> get props => [description];
}

class RoadmapCoverColorChanged extends RoadmapCreationEvent {
  final Color color;
  const RoadmapCoverColorChanged(this.color);
  @override
  List<Object?> get props => [color];
}

class RoadmapCoverImageChanged extends RoadmapCreationEvent {
  final String? path;
  const RoadmapCoverImageChanged(this.path);
  @override
  List<Object?> get props => [path];
}

class RoadmapSubjectChanged extends RoadmapCreationEvent {
  final String? subject;
  const RoadmapSubjectChanged(this.subject);
  @override
  List<Object?> get props => [subject];
}

class RoadmapLevelChanged extends RoadmapCreationEvent {
  final String level;
  const RoadmapLevelChanged(this.level);
  @override
  List<Object?> get props => [level];
}

class RoadmapDayAdded extends RoadmapCreationEvent {
  const RoadmapDayAdded();
}

class RoadmapDayRemoved extends RoadmapCreationEvent {
  final int dayIndex;
  const RoadmapDayRemoved(this.dayIndex);
  @override
  List<Object?> get props => [dayIndex];
}

// Kept for backward compat — totalDays stepper
class RoadmapTotalDaysChanged extends RoadmapCreationEvent {
  final int totalDays;
  const RoadmapTotalDaysChanged(this.totalDays);
  @override
  List<Object?> get props => [totalDays];
}

class DayTitleChanged extends RoadmapCreationEvent {
  final int dayIndex;
  final String title;
  const DayTitleChanged(this.dayIndex, this.title);
  @override
  List<Object?> get props => [dayIndex, title];
}

class TaskAddedToDay extends RoadmapCreationEvent {
  final int dayIndex;
  final RoadmapTaskDraft task;
  const TaskAddedToDay(this.dayIndex, this.task);
  @override
  List<Object?> get props => [dayIndex, task];
}

class TaskRemovedFromDay extends RoadmapCreationEvent {
  final int dayIndex;
  final int taskIndex;
  const TaskRemovedFromDay(this.dayIndex, this.taskIndex);
  @override
  List<Object?> get props => [dayIndex, taskIndex];
}

class TaskDescriptionChanged extends RoadmapCreationEvent {
  final int dayIndex;
  final int taskIndex;
  final String description;
  const TaskDescriptionChanged(this.dayIndex, this.taskIndex, this.description);
  @override
  List<Object?> get props => [dayIndex, taskIndex, description];
}

class TaskTypeChanged extends RoadmapCreationEvent {
  final int dayIndex;
  final int taskIndex;
  final SkillType skillType;
  const TaskTypeChanged(this.dayIndex, this.taskIndex, this.skillType);
  @override
  List<Object?> get props => [dayIndex, taskIndex, skillType];
}

class RoadmapPublishRequested extends RoadmapCreationEvent {
  const RoadmapPublishRequested();
}
