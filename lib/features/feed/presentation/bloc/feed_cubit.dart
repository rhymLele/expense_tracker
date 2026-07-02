import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../../topics/domain/entities/topic_entity.dart';
import '../../../topics/domain/usecases/apply_like_toggle_usecase.dart';
import '../../../topics/domain/usecases/toggle_like_usecase.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import 'feed_state.dart';

class FeedCubit extends LoadCubit<FeedState> {
  final GetFeedUseCase _getFeedUseCase;
  final ToggleLikeUseCase _toggleLikeUseCase;
  final ApplyLikeToggleUseCase _applyLikeToggle;
  static const _limit = 20;

  FeedCubit({
    required GetFeedUseCase getFeedUseCase,
    required ToggleLikeUseCase toggleLikeUseCase,
    required ApplyLikeToggleUseCase applyLikeToggleUseCase,
  })  : _getFeedUseCase = getFeedUseCase,
        _toggleLikeUseCase = toggleLikeUseCase,
        _applyLikeToggle = applyLikeToggleUseCase,
        super(const FeedState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: ViewStatus.loading, topics: [], page: 1));
    final result = await _getFeedUseCase(page: 1, limit: _limit);
    result.fold(
      (f) => emit(state.copyWith(status: ViewStatus.failure, error: f.message)),
      (p) => emit(state.copyWith(
        status: ViewStatus.success,
        topics: p.items,
        hasMore: p.items.length >= _limit,
        page: 1,
      )),
    );
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: ViewStatus.loading, page: 1));
    final result = await _getFeedUseCase(page: 1, limit: _limit);
    result.fold(
      (f) => emit(state.copyWith(status: ViewStatus.failure, error: f.message)),
      (p) => emit(state.copyWith(
        status: ViewStatus.success,
        topics: p.items,
        hasMore: p.items.length >= _limit,
        page: 1,
      )),
    );
  }

  Future<void> loadMore() async {
    if (state.status.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(status: ViewStatus.loadingMore));
    final nextPage = state.page + 1;
    final result = await _getFeedUseCase(page: nextPage, limit: _limit);
    result.fold(
      (_) => emit(state.copyWith(status: ViewStatus.success)),
      (p) => emit(state.copyWith(
        status: ViewStatus.success,
        topics: [...state.topics, ...p.items],
        hasMore: p.items.length >= _limit,
        page: nextPage,
      )),
    );
  }

  Future<void> likePost(String topicId) async {
    // Snapshot để revert nếu server lỗi
    final prevIds = Set<String>.from(state.likedTopicIds);
    final prevTopics = List<TopicEntity>.from(state.topics);

    // Optimistic: áp quy tắc like (nghiệp vụ nằm ở use case)
    final toggled = _applyLikeToggle(
      topicId: topicId,
      topics: state.topics,
      likedTopicIds: state.likedTopicIds,
    );
    emit(state.copyWith(
      likedTopicIds: toggled.likedTopicIds,
      topics: toggled.topics,
    ));

    final result = await _toggleLikeUseCase(topicId);
    result.fold(
      (_) => emit(state.copyWith(likedTopicIds: prevIds, topics: prevTopics)),
      (_) {},
    );
  }

  void incrementCommentCount(String topicId) {
    final updated = state.topics
        .map((t) =>
            t.id == topicId ? t.copyWith(commentCount: t.commentCount + 1) : t)
        .toList();
    emit(state.copyWith(topics: updated));
  }
}
