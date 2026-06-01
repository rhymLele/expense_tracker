import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../data/datasources/exercises_remote_datasource.dart';
import '../../../domain/entities/exercise_template_entity.dart';
import 'create_exercise_event.dart';
import 'create_exercise_state.dart';

class CreateExerciseBloc
    extends Bloc<CreateExerciseEvent, CreateExerciseState> {
  final ExercisesRemoteDataSource _datasource;

  CreateExerciseBloc({required ExercisesRemoteDataSource datasource})
      : _datasource = datasource,
        super(const CreateExerciseState()) {
    on<CreateExerciseInitialized>(_onInitialized);
    on<CreateExerciseTypeChanged>(_onTypeChanged);
    on<CreateExerciseTitleChanged>((e, emit) => emit(state.copyWith(title: e.title)));
    on<CreateExerciseQuestionChanged>((e, emit) => emit(state.copyWith(question: e.question)));
    on<CreateExerciseOptionChanged>(_onOptionChanged);
    on<CreateExerciseOptionAdded>(_onOptionAdded);
    on<CreateExerciseCorrectIndexChanged>(
        (e, emit) => emit(state.copyWith(correctIndex: e.index)));
    on<CreateExerciseFillTemplateChanged>(
        (e, emit) => emit(state.copyWith(fillTemplate: e.template)));
    on<CreateExerciseFillAnswerChanged>(
        (e, emit) => emit(state.copyWith(fillAnswer: e.answer)));
    on<CreateExerciseArrangeWordsChanged>(
        (e, emit) => emit(state.copyWith(arrangeWords: e.words)));
    on<CreateExerciseRecordingPromptChanged>(
        (e, emit) => emit(state.copyWith(recordingPrompt: e.prompt)));
    on<CreateExerciseEssayPromptChanged>(
        (e, emit) => emit(state.copyWith(essayPrompt: e.prompt)));
    on<CreateExerciseSubmitted>(_onSubmitted);
  }

  void _onInitialized(
    CreateExerciseInitialized event,
    Emitter<CreateExerciseState> emit,
  ) {
    final p = event.prefill;
    if (p == null) return;

    final options = _extractOptions(p);
    final correctIndex = _extractCorrectIndex(p);

    emit(state.copyWith(
      type: p.type,
      question: p.question,
      options: options,
      correctIndex: correctIndex,
      fillTemplate: p.config['template'] as String? ?? '',
      fillAnswer: p.config['answer'] as String? ?? '',
      arrangeWords: (p.config['words'] as List?)?.cast<String>() ?? [],
      recordingPrompt: p.config['prompt'] as String? ?? '',
      essayPrompt: p.config['prompt'] as String? ?? '',
    ));
  }

  void _onTypeChanged(
    CreateExerciseTypeChanged event,
    Emitter<CreateExerciseState> emit,
  ) {
    emit(state.copyWith(
      type: event.type,
      options: const ['', '', '', ''],
      correctIndex: 0,
    ));
  }

  void _onOptionChanged(
    CreateExerciseOptionChanged event,
    Emitter<CreateExerciseState> emit,
  ) {
    final updated = List<String>.from(state.options);
    if (event.index < updated.length) {
      updated[event.index] = event.value;
    }
    emit(state.copyWith(options: updated));
  }

  void _onOptionAdded(
    CreateExerciseOptionAdded event,
    Emitter<CreateExerciseState> emit,
  ) {
    if (state.options.length >= 6) return;
    emit(state.copyWith(options: [...state.options, '']));
  }

  Future<void> _onSubmitted(
    CreateExerciseSubmitted event,
    Emitter<CreateExerciseState> emit,
  ) async {
    final title = event.title.trim();
    final question = event.question.trim();

    if (title.isEmpty) {
      emit(state.copyWith(
        status: CreateExerciseStatus.failure,
        errorMessage: 'Vui lòng nhập tiêu đề bài tập',
      ));
      return;
    }
    if (question.isEmpty) {
      emit(state.copyWith(
        status: CreateExerciseStatus.failure,
        errorMessage: 'Vui lòng nhập nội dung câu hỏi',
      ));
      return;
    }

    emit(state.copyWith(status: CreateExerciseStatus.submitting));
    try {
      await _datasource.createExercise(
        type: state.type,
        title: title,
        question: question,
        config: state.buildConfig(),
      );
      emit(state.copyWith(status: CreateExerciseStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: CreateExerciseStatus.failure,
        errorMessage: e is AppException ? e.message : e.toString(),
      ));
    }
  }

  List<String> _extractOptions(ExerciseTemplateEntity p) {
    final raw = p.config['options'];
    if (raw is List) return raw.cast<String>();
    return ['', '', '', ''];
  }

  int _extractCorrectIndex(ExerciseTemplateEntity p) {
    return (p.answerKey?['correctIndex'] as int?) ??
        (p.config['correctIndex'] as int?) ??
        0;
  }
}
