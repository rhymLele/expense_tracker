import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/enrollments_remote_datasource.dart';
import 'roadmap_home_event.dart';
import 'roadmap_home_state.dart';

class RoadmapHomeBloc extends Bloc<RoadmapHomeEvent, RoadmapHomeState> {
  final EnrollmentsRemoteDataSource _ds;

  RoadmapHomeBloc({required EnrollmentsRemoteDataSource datasource})
      : _ds = datasource,
        super(const RoadmapHomeState()) {
    on<RoadmapHomeLoaded>(_onLoaded);
    on<RoadmapHomeRefreshed>(_onRefreshed);
    on<TaskToggled>(_onTaskToggled);
    on<QueueReordered>(_onQueueReordered);
    on<EnrollmentCancelled>(_onEnrollmentCancelled);
  }

  Future<void> _onLoaded(RoadmapHomeLoaded _, Emitter<RoadmapHomeState> emit) async {
    emit(state.copyWith(status: RoadmapHomeStatus.loading));
    await _fetch(emit);
  }

  Future<void> _onRefreshed(RoadmapHomeRefreshed _, Emitter<RoadmapHomeState> emit) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<RoadmapHomeState> emit) async {
    try {
      final active = await _ds.getActive();
      final all = await _ds.getMyEnrollments();

      final queue = all
          .where((e) => e.status == 'queued')
          .toList();

      emit(state.copyWith(
        status: RoadmapHomeStatus.success,
        active: active,
        queue: queue,
        completedTaskIds: {},
        isDayCompleted: false,
      ));
    } catch (e, st) {
      dev.log('RoadmapHomeBloc._fetch error: $e', stackTrace: st, name: 'RoadmapHome');
      emit(state.copyWith(
        status: RoadmapHomeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onTaskToggled(
    TaskToggled event,
    Emitter<RoadmapHomeState> emit,
  ) async {
    final updated = Set<String>.from(state.completedTaskIds);
    if (updated.contains(event.taskId)) {
      updated.remove(event.taskId);
    } else {
      updated.add(event.taskId);
    }

    final allDone = state.active != null &&
        state.active!.todayTasks.isNotEmpty &&
        updated.length >= state.active!.todayTasks.length;

    emit(state.copyWith(completedTaskIds: updated, isDayCompleted: allDone));

    // All tasks done → call completeDay (idempotent if called again)
    final activeId = state.active?.id;
    if (allDone && !state.isDayCompleted && activeId != null) {
      try {
        await _ds.completeDay(activeId);
        // Reload to get updated streak
        await _fetch(emit);
      } catch (e) {
        dev.log('completeDay error: $e', name: 'RoadmapHome');
      }
    }
  }

  Future<void> _onQueueReordered(
    QueueReordered event,
    Emitter<RoadmapHomeState> emit,
  ) async {
    // Optimistic: reorder locally first
    final reordered = event.orderedIds
        .map((id) => state.queue.firstWhere((e) => e.id == id))
        .toList();
    emit(state.copyWith(queue: reordered));

    try {
      await _ds.reorderQueue(event.orderedIds);
    } catch (e) {
      dev.log('reorderQueue error: $e', name: 'RoadmapHome');
      // Revert on failure
      await _fetch(emit);
    }
  }

  Future<void> _onEnrollmentCancelled(
    EnrollmentCancelled _,
    Emitter<RoadmapHomeState> emit,
  ) async {
    if (state.active == null) return;
    try {
      await _ds.cancel(state.active!.id);
      await _fetch(emit);
    } catch (e, st) {
      dev.log('cancel error: $e', stackTrace: st, name: 'RoadmapHome');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
