import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_today_tasks_usecase.dart';
import 'today_tasks_state.dart';

class TodayTasksCubit extends Cubit<TodayTasksState> {
  final GetTodayTasksUseCase _getTodayTasks;

  TodayTasksCubit({required GetTodayTasksUseCase getTodayTasks})
      : _getTodayTasks = getTodayTasks,
        super(const TodayTasksState());

  Future<void> load(String enrollmentId) async {
    emit(state.copyWith(status: TodayTasksStatus.loading));
    final result = await _getTodayTasks(enrollmentId);
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
