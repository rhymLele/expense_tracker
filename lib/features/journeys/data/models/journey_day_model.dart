import '../../../exercises/data/models/exercise_model.dart';
import '../../domain/entities/day_task_entity.dart';
import '../../domain/entities/journey_day_entity.dart';

class DayTaskModel extends DayTaskEntity {
  const DayTaskModel({
    required super.id,
    required super.dayId,
    required super.exerciseId,
    required super.order,
    required super.required,
    super.exercise,
  });

  factory DayTaskModel.fromJson(Map<String, dynamic> json) {
    final exerciseJson = json['exercise'] as Map<String, dynamic>?;
    return DayTaskModel(
      id: json['id'] as String,
      dayId: json['dayId'] as String,
      exerciseId: json['exerciseId'] as String,
      order: json['order'] as int? ?? 0,
      required: json['required'] as bool? ?? true,
      exercise: exerciseJson != null ? ExerciseModel.fromJson(exerciseJson) : null,
    );
  }
}

class JourneyDayModel extends JourneyDayEntity {
  const JourneyDayModel({
    required super.id,
    required super.journeyId,
    required super.dayNumber,
    super.title,
    super.unlockDate,
    super.tasks,
  });

  factory JourneyDayModel.fromJson(Map<String, dynamic> json) {
    final rawTasks = json['tasks'] as List? ?? [];
    return JourneyDayModel(
      id: json['id'] as String,
      journeyId: json['journeyId'] as String,
      dayNumber: json['dayNumber'] as int? ?? 1,
      title: json['title'] as String?,
      unlockDate: json['unlockDate'] != null ? DateTime.parse(json['unlockDate'] as String) : null,
      tasks: rawTasks.map((e) => DayTaskModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
