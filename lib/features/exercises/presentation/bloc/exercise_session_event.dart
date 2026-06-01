import 'package:equatable/equatable.dart';

abstract class ExerciseSessionEvent extends Equatable {
  const ExerciseSessionEvent();
  @override
  List<Object?> get props => [];
}

class ExerciseSessionStarted extends ExerciseSessionEvent {
  final String enrollmentId;
  const ExerciseSessionStarted(this.enrollmentId);
  @override
  List<Object?> get props => [enrollmentId];
}

class ExerciseAnswerSubmitted extends ExerciseSessionEvent {
  final Map<String, dynamic> answer;
  const ExerciseAnswerSubmitted(this.answer);
  @override
  List<Object?> get props => [answer];
}

class ExerciseFeedbackAcknowledged extends ExerciseSessionEvent {
  const ExerciseFeedbackAcknowledged();
}
