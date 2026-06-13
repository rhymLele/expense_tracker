import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_topic_usecase.dart';
import 'create_topic_state.dart';

class CreateTopicCubit extends Cubit<CreateTopicState> {
  final CreateTopicUseCase _createTopic;

  CreateTopicCubit({required CreateTopicUseCase createTopic})
      : _createTopic = createTopic,
        super(const CreateTopicState());

  void changeType(String type) => emit(state.copyWith(selectedType: type));

  void changeVisibility(String visibility) =>
      emit(state.copyWith(selectedVisibility: visibility));

  void dismissError() => emit(state.copyWith(status: CreateTopicStatus.initial));

  Future<void> submit({required String title, String? description}) async {
    emit(state.copyWith(status: CreateTopicStatus.loading));
    final result = await _createTopic(
      type: state.selectedType,
      title: title,
      description: description,
      visibility: state.selectedVisibility,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: CreateTopicStatus.failure,
        errorMessage: failure.message,
      )),
      (topic) => emit(state.copyWith(
        status: CreateTopicStatus.success,
        created: topic,
      )),
    );
  }
}
