import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'roadmap_creation_event.dart';
import 'roadmap_creation_models.dart';
import 'roadmap_creation_state.dart';

class RoadmapCreationBloc
    extends Bloc<RoadmapCreationEvent, RoadmapCreationState> {
  Timer? _draftDebounce;

  RoadmapCreationBloc() : super(const RoadmapCreationState()) {
    on<RoadmapInitialized>(_onInitialized);
    on<RoadmapTitleChanged>(_onTitleChanged);
    on<RoadmapDescriptionChanged>(_onDescriptionChanged);
    on<RoadmapCoverColorChanged>(_onCoverColorChanged);
    on<RoadmapCoverImageChanged>(_onCoverImageChanged);
    on<RoadmapSubjectChanged>(_onSubjectChanged);
    on<RoadmapLevelChanged>(_onLevelChanged);
    on<RoadmapDayAdded>(_onDayAdded);
    on<RoadmapDayRemoved>(_onDayRemoved);
    on<RoadmapTotalDaysChanged>(_onTotalDaysChanged);
    on<DayTitleChanged>(_onDayTitleChanged);
    on<TaskAddedToDay>(_onTaskAdded);
    on<TaskRemovedFromDay>(_onTaskRemoved);
    on<TaskDescriptionChanged>(_onTaskDescriptionChanged);
    on<TaskTypeChanged>(_onTaskTypeChanged);
    on<RoadmapPublishRequested>(_onPublishRequested);
  }

  @override
  Future<void> close() {
    _draftDebounce?.cancel();
    return super.close();
  }

  void _onInitialized(
    RoadmapInitialized _,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(state.copyWith(days: [const RoadmapDayDraft()], totalDays: 1));
  }

  void _onTitleChanged(
    RoadmapTitleChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(state.copyWith(title: event.title, draftSaved: false));
    _scheduleDraftSave();
  }

  void _onDescriptionChanged(
    RoadmapDescriptionChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(state.copyWith(description: event.description, draftSaved: false));
    _scheduleDraftSave();
  }

  void _onCoverColorChanged(
    RoadmapCoverColorChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(
      state.copyWith(
        coverColor: event.color,
        coverImagePath: null, // reset image when solid color is chosen
      ),
    );
  }

  void _onCoverImageChanged(
    RoadmapCoverImageChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(state.copyWith(coverImagePath: event.path));
  }

  void _onSubjectChanged(
    RoadmapSubjectChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    // Toggle: tap again to deselect
    final next = state.subject == event.subject ? null : event.subject;
    emit(state.copyWith(subject: next));
  }

  void _onLevelChanged(
    RoadmapLevelChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    emit(state.copyWith(level: event.level));
  }

  void _onDayAdded(RoadmapDayAdded _, Emitter<RoadmapCreationState> emit) {
    final days = [...state.days, const RoadmapDayDraft()];
    emit(state.copyWith(days: days, totalDays: days.length));
  }

  void _onDayRemoved(
    RoadmapDayRemoved event,
    Emitter<RoadmapCreationState> emit,
  ) {
    if (state.days.length <= 1) return; // keep at least 1 day
    final days = List<RoadmapDayDraft>.from(state.days)
      ..removeAt(event.dayIndex);
    emit(state.copyWith(days: days, totalDays: days.length));
  }

  void _onTotalDaysChanged(
    RoadmapTotalDaysChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    final newTotal = event.totalDays.clamp(1, 90);
    final current = state.days;
    final List<RoadmapDayDraft> updated;
    if (newTotal > current.length) {
      updated = [
        ...current,
        ...List.generate(
          newTotal - current.length,
          (_) => const RoadmapDayDraft(),
        ),
      ];
    } else {
      updated = current.take(newTotal).toList();
    }
    emit(state.copyWith(totalDays: newTotal, days: updated));
  }

  void _onDayTitleChanged(
    DayTitleChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (event.dayIndex >= days.length) return;
    days[event.dayIndex] = days[event.dayIndex].copyWith(title: event.title);
    emit(state.copyWith(days: days));
  }

  void _onTaskAdded(TaskAddedToDay event, Emitter<RoadmapCreationState> emit) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (event.dayIndex >= days.length) return;
    final day = days[event.dayIndex];
    days[event.dayIndex] = day.copyWith(tasks: [...day.tasks, event.task]);
    emit(state.copyWith(days: days));
  }

  void _onTaskRemoved(
    TaskRemovedFromDay event,
    Emitter<RoadmapCreationState> emit,
  ) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (event.dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[event.dayIndex].tasks);
    if (event.taskIndex >= tasks.length) return;
    tasks.removeAt(event.taskIndex);
    days[event.dayIndex] = days[event.dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  void _onTaskDescriptionChanged(
    TaskDescriptionChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (event.dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[event.dayIndex].tasks);
    if (event.taskIndex >= tasks.length) return;
    tasks[event.taskIndex] = tasks[event.taskIndex].copyWith(
      title: event.description,
    );
    days[event.dayIndex] = days[event.dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  void _onTaskTypeChanged(
    TaskTypeChanged event,
    Emitter<RoadmapCreationState> emit,
  ) {
    final days = List<RoadmapDayDraft>.from(state.days);
    if (event.dayIndex >= days.length) return;
    final tasks = List<RoadmapTaskDraft>.from(days[event.dayIndex].tasks);
    if (event.taskIndex >= tasks.length) return;
    tasks[event.taskIndex] = tasks[event.taskIndex].copyWith(
      type: event.skillType,
    );
    days[event.dayIndex] = days[event.dayIndex].copyWith(tasks: tasks);
    emit(state.copyWith(days: days));
  }

  Future<void> _onPublishRequested(
    RoadmapPublishRequested _,
    Emitter<RoadmapCreationState> emit,
  ) async {
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
      emit(
        state.copyWith(
          status: RoadmapCreationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _scheduleDraftSave() {
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 300), () {
      // TODO: persist draft
    });
  }
}
