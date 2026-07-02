import '../../../../../core/base/base_cubit.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../data/datasources/exercises_remote_datasource.dart';
import '../../../domain/entities/exercise_template_entity.dart';
import 'create_exercise_state.dart';

class CreateExerciseCubit extends BaseCubit<CreateExerciseState> {
  final ExercisesRemoteDataSource _datasource;

  CreateExerciseCubit({required ExercisesRemoteDataSource datasource})
      : _datasource = datasource,
        super(const CreateExerciseState());

  /// Form-driven — khởi tạo qua [initialize] từ UI.
  @override
  Future<void> fetchData() async {}

  void initialize({ExerciseTemplateEntity? prefill}) {
    if (prefill == null) return;

    final options = _extractOptions(prefill);
    final correctIndex = _extractCorrectIndex(prefill);

    emit(state.copyWith(
      type: prefill.type,
      question: prefill.question,
      options: options,
      correctIndex: correctIndex,
      fillTemplate: prefill.config['template'] as String? ?? '',
      fillAnswer: prefill.config['answer'] as String? ?? '',
      arrangeWords: (prefill.config['words'] as List?)?.cast<String>() ?? [],
      recordingPrompt: prefill.config['prompt'] as String? ?? '',
      essayPrompt: prefill.config['prompt'] as String? ?? '',
    ));
  }

  void changeType(String type) {
    emit(state.copyWith(
      type: type,
      options: const ['', '', '', ''],
      correctIndex: 0,
    ));
  }

  void changeTitle(String title) => emit(state.copyWith(title: title));
  void changeQuestion(String question) => emit(state.copyWith(question: question));

  void changeOption(int index, String value) {
    final updated = List<String>.from(state.options);
    if (index < updated.length) updated[index] = value;
    emit(state.copyWith(options: updated));
  }

  void addOption() {
    if (state.options.length >= 6) return;
    emit(state.copyWith(options: [...state.options, '']));
  }

  void changeCorrectIndex(int index) => emit(state.copyWith(correctIndex: index));
  void changeFillTemplate(String template) => emit(state.copyWith(fillTemplate: template));
  void changeFillAnswer(String answer) => emit(state.copyWith(fillAnswer: answer));
  void changeArrangeWords(List<String> words) => emit(state.copyWith(arrangeWords: words));
  void changeRecordingPrompt(String prompt) => emit(state.copyWith(recordingPrompt: prompt));
  void changeEssayPrompt(String prompt) => emit(state.copyWith(essayPrompt: prompt));

  Future<void> submit({required String title, required String question}) async {
    final t = title.trim();
    final q = question.trim();

    if (t.isEmpty) {
      emit(state.copyWith(
        status: CreateExerciseStatus.failure,
        errorMessage: 'Vui lòng nhập tiêu đề bài tập',
      ));
      return;
    }
    if (q.isEmpty) {
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
        title: t,
        question: q,
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
