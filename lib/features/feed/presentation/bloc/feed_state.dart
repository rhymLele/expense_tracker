import '../../../../core/base/base_state.dart';
import '../../../topics/domain/entities/topic_entity.dart';

class FeedState extends BaseState<FeedState> {
  final List<TopicEntity> topics;
  final bool hasMore;
  final int page;
  final Set<String> likedTopicIds;

  const FeedState({
    super.status,
    super.error,
    this.topics = const [],
    this.hasMore = true,
    this.page = 1,
    this.likedTopicIds = const {},
  });

  FeedState copyWith({
    ViewStatus? status,
    List<TopicEntity>? topics,
    bool? hasMore,
    int? page,
    String? error,
    Set<String>? likedTopicIds,
  }) =>
      FeedState(
        status: status ?? this.status,
        topics: topics ?? this.topics,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
        likedTopicIds: likedTopicIds ?? this.likedTopicIds,
      );

  /// Đang tải lần đầu (chưa có gì để hiển thị) → loading toàn trang.
  bool get isInitialLoading => status.isLoading && topics.isEmpty;

  /// Lỗi khi chưa có dữ liệu → trang lỗi + thử lại.
  bool get isInitialError => status.isFailure && topics.isEmpty;

  /// Tải xong nhưng rỗng → hiển thị bài mẫu (seed).
  bool get showSeedPosts => status.isSuccess && topics.isEmpty;

  @override
  FeedState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [
        status,
        error,
        topics,
        hasMore,
        page,
        (likedTopicIds.toList()..sort()),
      ];
}
