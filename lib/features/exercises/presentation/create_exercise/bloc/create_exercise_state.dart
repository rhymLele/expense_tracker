import 'package:equatable/equatable.dart';

enum CreateExerciseStatus { idle, submitting, success, failure }

class CreateExerciseState extends Equatable {
  final CreateExerciseStatus status;
  final String type;
  final String title;
  final String question;
  // MCQ
  final List<String> options;
  final int correctIndex;
  // Fill blank
  final String fillTemplate;
  final String fillAnswer;
  // Arrange
  final List<String> arrangeWords;
  // Recording
  final String recordingPrompt;
  // Essay
  final String essayPrompt;
  final String? errorMessage;

  const CreateExerciseState({
    this.status = CreateExerciseStatus.idle,
    this.type = 'multiple_choice',
    this.title = '',
    this.question = '',
    this.options = const ['', '', '', ''],
    this.correctIndex = 0,
    this.fillTemplate = '',
    this.fillAnswer = '',
    this.arrangeWords = const [],
    this.recordingPrompt = '',
    this.essayPrompt = '',
    this.errorMessage,
  });

  Map<String, dynamic> buildConfig() {
    return switch (type) {
      'multiple_choice' => {
          'options': options,
          'correctIndex': correctIndex,
        },
      'fill_blank' => {
          'template': fillTemplate,
          'answer': fillAnswer,
        },
      'arrange' => {
          'words': arrangeWords,
        },
      'recording' => {
          'prompt': recordingPrompt,
        },
      'essay' => {
          'prompt': essayPrompt,
        },
      _ => <String, dynamic>{},
    };
  }

  CreateExerciseState copyWith({
    CreateExerciseStatus? status,
    String? type,
    String? title,
    String? question,
    List<String>? options,
    int? correctIndex,
    String? fillTemplate,
    String? fillAnswer,
    List<String>? arrangeWords,
    String? recordingPrompt,
    String? essayPrompt,
    String? errorMessage,
  }) =>
      CreateExerciseState(
        status: status ?? this.status,
        type: type ?? this.type,
        title: title ?? this.title,
        question: question ?? this.question,
        options: options ?? this.options,
        correctIndex: correctIndex ?? this.correctIndex,
        fillTemplate: fillTemplate ?? this.fillTemplate,
        fillAnswer: fillAnswer ?? this.fillAnswer,
        arrangeWords: arrangeWords ?? this.arrangeWords,
        recordingPrompt: recordingPrompt ?? this.recordingPrompt,
        essayPrompt: essayPrompt ?? this.essayPrompt,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        type,
        title,
        question,
        options,
        correctIndex,
        fillTemplate,
        fillAnswer,
        arrangeWords,
        recordingPrompt,
        essayPrompt,
        errorMessage,
      ];
}
