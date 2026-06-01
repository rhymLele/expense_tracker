import 'package:equatable/equatable.dart';

sealed class CreateTopicEvent extends Equatable {
  const CreateTopicEvent();
  @override
  List<Object?> get props => [];
}

final class CreateTopicTypeChanged extends CreateTopicEvent {
  final String type;
  const CreateTopicTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

final class CreateTopicVisibilityChanged extends CreateTopicEvent {
  final String visibility;
  const CreateTopicVisibilityChanged(this.visibility);
  @override
  List<Object?> get props => [visibility];
}

final class CreateTopicSubmitted extends CreateTopicEvent {
  final String title;
  final String? description;
  const CreateTopicSubmitted({required this.title, this.description});
  @override
  List<Object?> get props => [title, description];
}

final class CreateTopicErrorDismissed extends CreateTopicEvent {
  const CreateTopicErrorDismissed();
}
