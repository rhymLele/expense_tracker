import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_topic_usecase.dart';
import 'create_topic_event.dart';
import 'create_topic_state.dart';

class CreateTopicBloc extends Bloc<CreateTopicEvent, CreateTopicState> {
  final CreateTopicUseCase _createTopic;

  CreateTopicBloc({required CreateTopicUseCase createTopic})
      : _createTopic = createTopic,
        super(const CreateTopicState()) {
    on<CreateTopicTypeChanged>(_onTypeChanged);
    on<CreateTopicVisibilityChanged>(_onVisibilityChanged);
    on<CreateTopicSubmitted>(_onSubmitted);
    on<CreateTopicErrorDismissed>(_onErrorDismissed);
  }

  void _onTypeChanged(CreateTopicTypeChanged e, Emitter<CreateTopicState> emit) =>
      emit(state.copyWith(selectedType: e.type));

  void _onVisibilityChanged(
          CreateTopicVisibilityChanged e, Emitter<CreateTopicState> emit) =>
      emit(state.copyWith(selectedVisibility: e.visibility));

  void _onErrorDismissed(
          CreateTopicErrorDismissed e, Emitter<CreateTopicState> emit) =>
      emit(state.copyWith(status: CreateTopicStatus.initial));

  Future<void> _onSubmitted(
    CreateTopicSubmitted event,
    Emitter<CreateTopicState> emit,
  ) async {
    emit(state.copyWith(status: CreateTopicStatus.loading));
    final result = await _createTopic(
      type: state.selectedType,
      title: event.title,
      description: event.description,
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
