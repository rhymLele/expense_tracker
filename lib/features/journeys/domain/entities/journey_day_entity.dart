import 'package:equatable/equatable.dart';

import 'day_task_entity.dart';

class JourneyDayEntity extends Equatable {
  final String id;
  final String journeyId;
  final int dayNumber;
  final String? title;
  final DateTime? unlockDate;
  final List<DayTaskEntity> tasks;

  const JourneyDayEntity({
    required this.id,
    required this.journeyId,
    required this.dayNumber,
    this.title,
    this.unlockDate,
    this.tasks = const [],
  });

  @override
  List<Object?> get props => [id, journeyId, dayNumber];
}
