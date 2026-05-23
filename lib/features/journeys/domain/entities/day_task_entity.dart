import 'package:equatable/equatable.dart';

import '../../../exercises/domain/entities/exercise_entity.dart';

class DayTaskEntity extends Equatable {
  final String id;
  final String dayId;
  final String exerciseId;
  final int order;
  final bool required;
  final ExerciseEntity? exercise;

  const DayTaskEntity({
    required this.id,
    required this.dayId,
    required this.exerciseId,
    required this.order,
    required this.required,
    this.exercise,
  });

  @override
  List<Object?> get props => [id, dayId, exerciseId, order, required];
}
