import 'package:equatable/equatable.dart';

abstract class TodayTasksEvent extends Equatable {
  const TodayTasksEvent();
  @override
  List<Object?> get props => [];
}

class TodayTasksLoadRequested extends TodayTasksEvent {
  final String enrollmentId;
  const TodayTasksLoadRequested(this.enrollmentId);
  @override
  List<Object?> get props => [enrollmentId];
}
