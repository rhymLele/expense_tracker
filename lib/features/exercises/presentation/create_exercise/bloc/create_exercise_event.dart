import 'package:equatable/equatable.dart';

import '../../../domain/entities/exercise_template_entity.dart';

abstract class CreateExerciseEvent extends Equatable {
  const CreateExerciseEvent();
  @override
  List<Object?> get props => [];
}

class CreateExerciseInitialized extends CreateExerciseEvent {
  final ExerciseTemplateEntity? prefill;
  const CreateExerciseInitialized({this.prefill});
  @override
  List<Object?> get props => [prefill];
}

class CreateExerciseTypeChanged extends CreateExerciseEvent {
  final String type;
  const CreateExerciseTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class CreateExerciseTitleChanged extends CreateExerciseEvent {
  final String title;
  const CreateExerciseTitleChanged(this.title);
  @override
  List<Object?> get props => [title];
}

class CreateExerciseQuestionChanged extends CreateExerciseEvent {
  final String question;
  const CreateExerciseQuestionChanged(this.question);
  @override
  List<Object?> get props => [question];
}

class CreateExerciseOptionChanged extends CreateExerciseEvent {
  final int index;
  final String value;
  const CreateExerciseOptionChanged(this.index, this.value);
  @override
  List<Object?> get props => [index, value];
}

class CreateExerciseOptionAdded extends CreateExerciseEvent {
  const CreateExerciseOptionAdded();
}

class CreateExerciseCorrectIndexChanged extends CreateExerciseEvent {
  final int index;
  const CreateExerciseCorrectIndexChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class CreateExerciseFillTemplateChanged extends CreateExerciseEvent {
  final String template;
  const CreateExerciseFillTemplateChanged(this.template);
  @override
  List<Object?> get props => [template];
}

class CreateExerciseFillAnswerChanged extends CreateExerciseEvent {
  final String answer;
  const CreateExerciseFillAnswerChanged(this.answer);
  @override
  List<Object?> get props => [answer];
}

class CreateExerciseArrangeWordsChanged extends CreateExerciseEvent {
  final List<String> words;
  const CreateExerciseArrangeWordsChanged(this.words);
  @override
  List<Object?> get props => [words];
}

class CreateExerciseRecordingPromptChanged extends CreateExerciseEvent {
  final String prompt;
  const CreateExerciseRecordingPromptChanged(this.prompt);
  @override
  List<Object?> get props => [prompt];
}

class CreateExerciseEssayPromptChanged extends CreateExerciseEvent {
  final String prompt;
  const CreateExerciseEssayPromptChanged(this.prompt);
  @override
  List<Object?> get props => [prompt];
}

class CreateExerciseSubmitted extends CreateExerciseEvent {
  final String title;
  final String question;
  const CreateExerciseSubmitted({required this.title, required this.question});
  @override
  List<Object?> get props => [title, question];
}
