import '../../../../../core/base/base_cubit.dart';
import '../../../../../core/base/base_state.dart';
import '../../../domain/usecases/create_topic_usecase.dart';
import 'create_topic_state.dart';

class CreateTopicCubit extends LoadCubit<CreateTopicState> {
  final CreateTopicUseCase _createTopic;

  CreateTopicCubit({required CreateTopicUseCase createTopic})
      : _createTopic = createTopic,
        super(const CreateTopicState());

  /// Không có load ban đầu — topic được submit từ UI.
  @override
  Future<void> fetchData() async {}

  void changeType(String type) => emit(state.copyWith(selectedType: type));

  void changeVisibility(String visibility) =>
      emit(state.copyWith(selectedVisibility: visibility));

  void dismissError() => emit(state.copyWith(status: ViewStatus.initial));

  Future<void> submit({required String title, String? description}) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _createTopic(
      type: state.selectedType,
      title: title,
      description: description,
      visibility: state.selectedVisibility,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, error: failure.message)),
      (topic) => emit(state.copyWith(
        status: ViewStatus.success,
        created: topic,
      )),
    );
  }
}
