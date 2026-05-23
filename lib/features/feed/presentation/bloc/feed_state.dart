import 'package:equatable/equatable.dart';

import '../../../topics/domain/entities/topic_entity.dart';

enum FeedStatus { initial, loading, success, failure, loadingMore }

class FeedState extends Equatable {
  final FeedStatus status;
  final List<TopicEntity> topics;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  const FeedState({
    this.status = FeedStatus.initial,
    this.topics = const [],
    this.hasMore = true,
    this.page = 1,
    this.errorMessage,
  });

  FeedState copyWith({
    FeedStatus? status,
    List<TopicEntity>? topics,
    bool? hasMore,
    int? page,
    String? errorMessage,
  }) =>
      FeedState(
        status: status ?? this.status,
        topics: topics ?? this.topics,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, topics, hasMore, page, errorMessage];
}
