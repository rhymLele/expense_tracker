import '../../../../core/base/base_state.dart';
import '../../domain/entities/today_tasks_entity.dart';

class TodayTasksState extends BaseState<TodayTasksState> {
  final TodayTasksEntity? todayTasks;

  const TodayTasksState({
    super.status,
    super.error,
    this.todayTasks,
  });

  TodayTasksState copyWith({
    ViewStatus? status,
    TodayTasksEntity? todayTasks,
    String? error,
  }) =>
      TodayTasksState(
        status: status ?? this.status,
        todayTasks: todayTasks ?? this.todayTasks,
        error: error,
      );

  @override
  TodayTasksState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [status, error, todayTasks];
}
