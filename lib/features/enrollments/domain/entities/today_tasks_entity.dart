import 'package:equatable/equatable.dart';

import '../../../journeys/domain/entities/journey_day_entity.dart';

class TodayTasksEntity extends Equatable {
  final int currentDay;
  final JourneyDayEntity day;
  final List<String> submittedTaskIds;

  const TodayTasksEntity({
    required this.currentDay,
    required this.day,
    required this.submittedTaskIds,
  });

  @override
  List<Object?> get props => [currentDay, day.id];
}
