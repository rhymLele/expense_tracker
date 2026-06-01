import 'package:equatable/equatable.dart';

import '../../domain/entities/today_tasks_entity.dart';

enum TodayTasksStatus { initial, loading, success, failure }

class TodayTasksState extends Equatable {
  final TodayTasksStatus status;
  final TodayTasksEntity? todayTasks;
  final String? errorMessage;

  const TodayTasksState({
    this.status = TodayTasksStatus.initial,
    this.todayTasks,
    this.errorMessage,
  });

  TodayTasksState copyWith({
    TodayTasksStatus? status,
    TodayTasksEntity? todayTasks,
    String? errorMessage,
  }) =>
      TodayTasksState(
        status: status ?? this.status,
        todayTasks: todayTasks ?? this.todayTasks,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, todayTasks, errorMessage];
}
