import '../../../../../core/base/base_state.dart';
import '../../../domain/entities/topic_entity.dart';

class CreateTopicState extends BaseState<CreateTopicState> {
  final String selectedType;
  final String selectedVisibility;
  final TopicEntity? created;

  const CreateTopicState({
    super.status,
    super.error,
    this.selectedType = 'lesson',
    this.selectedVisibility = 'public',
    this.created,
  });

  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isFailure => status.isFailure;

  CreateTopicState copyWith({
    ViewStatus? status,
    String? selectedType,
    String? selectedVisibility,
    String? error,
    TopicEntity? created,
  }) =>
      CreateTopicState(
        status: status ?? this.status,
        selectedType: selectedType ?? this.selectedType,
        selectedVisibility: selectedVisibility ?? this.selectedVisibility,
        error: error,
        created: created ?? this.created,
      );

  @override
  CreateTopicState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props =>
      [status, error, selectedType, selectedVisibility, created];
}
