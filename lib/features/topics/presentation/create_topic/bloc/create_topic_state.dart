import 'package:equatable/equatable.dart';
import '../../../domain/entities/topic_entity.dart';

enum CreateTopicStatus { initial, loading, success, failure }

class CreateTopicState extends Equatable {
  final CreateTopicStatus status;
  final String selectedType;
  final String selectedVisibility;
  final String? errorMessage;
  final TopicEntity? created;

  const CreateTopicState({
    this.status = CreateTopicStatus.initial,
    this.selectedType = 'lesson',
    this.selectedVisibility = 'public',
    this.errorMessage,
    this.created,
  });

  bool get isLoading => status == CreateTopicStatus.loading;
  bool get isSuccess => status == CreateTopicStatus.success;
  bool get isFailure => status == CreateTopicStatus.failure;

  CreateTopicState copyWith({
    CreateTopicStatus? status,
    String? selectedType,
    String? selectedVisibility,
    String? errorMessage,
    TopicEntity? created,
  }) =>
      CreateTopicState(
        status: status ?? this.status,
        selectedType: selectedType ?? this.selectedType,
        selectedVisibility: selectedVisibility ?? this.selectedVisibility,
        errorMessage: errorMessage,
        created: created ?? this.created,
      );

  @override
  List<Object?> get props =>
      [status, selectedType, selectedVisibility, errorMessage, created];
}
