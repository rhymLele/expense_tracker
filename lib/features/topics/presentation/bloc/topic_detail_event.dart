import 'package:equatable/equatable.dart';

abstract class TopicDetailEvent extends Equatable {
  const TopicDetailEvent();
  @override
  List<Object?> get props => [];
}

class TopicDetailLoadRequested extends TopicDetailEvent {
  final String topicId;
  const TopicDetailLoadRequested(this.topicId);
  @override
  List<Object?> get props => [topicId];
}

class TopicDetailLikeToggled extends TopicDetailEvent {
  const TopicDetailLikeToggled();
}

class TopicDetailCommentSubmitted extends TopicDetailEvent {
  final String content;
  const TopicDetailCommentSubmitted(this.content);
  @override
  List<Object?> get props => [content];
}
