import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_today_tasks_usecase.dart';
import 'today_tasks_event.dart';
import 'today_tasks_state.dart';

class TodayTasksBloc extends Bloc<TodayTasksEvent, TodayTasksState> {
  final GetTodayTasksUseCase _getTodayTasks;

  TodayTasksBloc({required GetTodayTasksUseCase getTodayTasks})
      : _getTodayTasks = getTodayTasks,
        super(const TodayTasksState()) {
    on<TodayTasksLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    TodayTasksLoadRequested event,
    Emitter<TodayTasksState> emit,
  ) async {
    emit(state.copyWith(status: TodayTasksStatus.loading));
    final result = await _getTodayTasks(event.enrollmentId);
    result.fold(
      (f) => emit(state.copyWith(
        status: TodayTasksStatus.failure,
        errorMessage: f.message,
      )),
      (tasks) => emit(state.copyWith(
        status: TodayTasksStatus.success,
        todayTasks: tasks,
      )),
    );
  }
}
