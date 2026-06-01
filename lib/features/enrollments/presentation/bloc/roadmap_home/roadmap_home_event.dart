import 'package:equatable/equatable.dart';

abstract class RoadmapHomeEvent extends Equatable {
  const RoadmapHomeEvent();
  @override
  List<Object?> get props => [];
}

class RoadmapHomeLoaded extends RoadmapHomeEvent {
  const RoadmapHomeLoaded();
}

class RoadmapHomeRefreshed extends RoadmapHomeEvent {
  const RoadmapHomeRefreshed();
}

class TaskToggled extends RoadmapHomeEvent {
  final String taskId;
  const TaskToggled(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class QueueReordered extends RoadmapHomeEvent {
  final List<String> orderedIds;
  const QueueReordered(this.orderedIds);
  @override
  List<Object?> get props => [orderedIds];
}

class EnrollmentCancelled extends RoadmapHomeEvent {
  const EnrollmentCancelled();
}
