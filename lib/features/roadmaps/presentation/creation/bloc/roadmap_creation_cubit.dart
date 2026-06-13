import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'roadmap_creation_models.dart';
import 'roadmap_creation_state.dart';

class RoadmapCreationCubit extends Cubit<RoadmapCreationState> {
  Timer? _draftDebounce;

  RoadmapCreationCubit() : super(const RoadmapCreationState());

  @override
  Future<void> close() {
    _draftDebounce?.cancel();
    return super.close();
  }

  void initialize() {
    emit(state.copyWith(days: [const RoadmapDayDraft()], totalDays: 1));
  }

  void changeTitle(String title) {
    emit(state.copyWith(title: title, draftSaved: false));
    _scheduleDraftSave();
  }

  void changeDescription(String description) {
    emit(state.copyWith(description: description, draftSaved: false));
    _scheduleDraftSave();
  }

  void changeCoverColor(Color color) {
    emit(state.copyWith(coverColor: color, coverImagePath: null));
  }

  void changeCoverImage(String? path) {
    emit(state.copyWith(coverImagePath: path));
  }

  void changeSubject(String? subject) {
    final next = state.subject == subject ? null : subject;
    emit(state.copyWith(subject: next));
  }

  void changeLevel(String level) {
    emit(state.copyWith(level: level));
  }

  void addDay() {
    final days = [...state.days, const RoadmapDayDraft()];
    emit(state.copyWith(days: days, totalDays: days.length));
  }

  void removeDay(int dayIndex) {
    if (state.days.length <= 1) return;
    final days = List<RoadmapDayDraft>.from(state.days)..removeAt(dayIndex);
    emit(state.copyWith(days: days, totalDays: days.length));
  }

  void changeTotalDays(int totalDays) {
    final newTotal = totalDays.clamp(1, 90);
    final current = state.days;
    final List<RoadmapDayDraft> updated;
    if (newTotal > current.length) {
      updated = [
        ...current,
        ...List.generate(newTotal - current.length, (_) => const RoadmapDayDraft()),
      ];
    } else {
      updated = current.take(newTotal).toList();
    }
    emit(state.copyWith(totalDays: newTotal, days: updated));
  }

  void changeDayTitle(int dayIndex, String title) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (dayIndex >= days.length) return;
    days[dayIndex] = days[dayIndex].copyWith(title: title);
    emit(state.copyWith(days: days));
  }

  void addTaskToDay(int dayIndex, RoadmapTaskDraft task) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (dayIndex >= days.length) return;
    final day = days[dayIndex];
    days[dayIndex] = day.copyWith(tasks: [...day.tasks, task]);
    emit(state.copyWith(days: days));
  }

  void removeTaskFromDay(int dayIndex, int taskIndex) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[dayIndex].tasks);
    if (taskIndex >= tasks.length) return;
    tasks.removeAt(taskIndex);
    days[dayIndex] = days[dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  void changeTaskDescription(int dayIndex, int taskIndex, String description) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[dayIndex].tasks);
    if (taskIndex >= tasks.length) return;
    tasks[taskIndex] = tasks[taskIndex].copyWith(title: description);
    days[dayIndex] = days[dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  void changeTaskType(int dayIndex, int taskIndex, SkillType skillType) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[dayIndex].tasks);
    if (taskIndex >= tasks.length) return;
    tasks[taskIndex] = tasks[taskIndex].copyWith(type: skillType);
    days[dayIndex] = days[dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  Future<void> publish() async {
    final msg = state.publishValidationMessage;
    if (msg != null) {
      emit(state.copyWith(validationMessage: msg));
      return;
    }
    emit(state.copyWith(status: RoadmapCreationStatus.publishing));
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(status: RoadmapCreationStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RoadmapCreationStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _scheduleDraftSave() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 300), () {
      // TODO: persist draft
    });
  }
}
