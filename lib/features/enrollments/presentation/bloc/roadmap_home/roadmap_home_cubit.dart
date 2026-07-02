import 'dart:developer' as dev;

import '../../../../../core/base/base_cubit.dart';
import '../../../../../core/base/base_state.dart';
import '../../../data/datasources/enrollments_remote_datasource.dart';
import 'roadmap_home_state.dart';

class RoadmapHomeCubit extends LoadCubit<RoadmapHomeState> {
  final EnrollmentsRemoteDataSource _ds;

  RoadmapHomeCubit({required EnrollmentsRemoteDataSource datasource})
      : _ds = datasource,
        super(const RoadmapHomeState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));
    await _fetch();
  }

  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    try {
      final active = await _ds.getActive();
      final all = await _ds.getMyEnrollments();

      final queue = all.where((e) => e.status == 'queued').toList();

      emit(state.copyWith(
        status: ViewStatus.success,
        active: active,
        queue: queue,
        completedTaskIds: {},
        isDayCompleted: false,
      ));
    } catch (e, st) {
      dev.log('RoadmapHomeCubit._fetch error: $e',
          stackTrace: st, name: 'RoadmapHome');
      emit(state.copyWith(status: ViewStatus.failure, error: e.toString()));
    }
  }

  Future<void> toggleTask(String taskId) async {
    final updated = Set<String>.from(state.completedTaskIds);
    if (updated.contains(taskId)) {
      updated.remove(taskId);
    } else {
      updated.add(taskId);
    }

    final allDone = state.active != null &&
        state.active!.todayTasks.isNotEmpty &&
        updated.length >= state.active!.todayTasks.length;

    emit(state.copyWith(completedTaskIds: updated, isDayCompleted: allDone));

    final activeId = state.active?.id;
    if (allDone && !state.isDayCompleted && activeId != null) {
      try {
        await _ds.completeDay(activeId);
        await _fetch();
      } catch (e) {
        dev.log('completeDay error: $e', name: 'RoadmapHome');
      }
    }
  }

  Future<void> reorderQueue(List<String> orderedIds) async {
    final reordered = orderedIds
        .map((id) => state.queue.firstWhere((e) => e.id == id))
        .toList();
    emit(state.copyWith(queue: reordered));

    try {
      await _ds.reorderQueue(orderedIds);
    } catch (e) {
      dev.log('reorderQueue error: $e', name: 'RoadmapHome');
      await _fetch();
    }
  }

  Future<void> cancelEnrollment() async {
    if (state.active == null) return;
    try {
      await _ds.cancel(state.active!.id);
      await _fetch();
    } catch (e, st) {
      dev.log('cancel error: $e', stackTrace: st, name: 'RoadmapHome');
      emit(state.copyWith(error: e.toString()));
    }
  }
}
