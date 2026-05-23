import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_feed_usecase.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetFeedUseCase _getFeedUseCase;
  static const _limit = 20;

  FeedBloc({required GetFeedUseCase getFeedUseCase})
      : _getFeedUseCase = getFeedUseCase,
        super(const FeedState()) {
    on<FeedLoadRequested>(_onLoad);
    on<FeedRefreshRequested>(_onRefresh);
    on<FeedLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onLoad(
    FeedLoadRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state.status == FeedStatus.loading) return;
    emit(state.copyWith(status: FeedStatus.loading, topics: [], page: 1));
    final result = await _getFeedUseCase(page: 1, limit: _limit);
    result.fold(
      (f) => emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: f.message,
      )),
      (p) => emit(state.copyWith(
        status: FeedStatus.success,
        topics: p.items,
        hasMore: p.items.length >= _limit,
        page: 1,
      )),
    );
  }

  Future<void> _onRefresh(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading, page: 1));
    final result = await _getFeedUseCase(page: 1, limit: _limit);
    result.fold(
      (f) => emit(state.copyWith(
        status: FeedStatus.failure,
        errorMessage: f.message,
      )),
      (p) => emit(state.copyWith(
        status: FeedStatus.success,
        topics: p.items,
        hasMore: p.items.length >= _limit,
        page: 1,
      )),
    );
  }

  Future<void> _onLoadMore(
    FeedLoadMoreRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state.status == FeedStatus.loadingMore || !state.hasMore) return;
    emit(state.copyWith(status: FeedStatus.loadingMore));
    final nextPage = state.page + 1;
    final result = await _getFeedUseCase(page: nextPage, limit: _limit);
    result.fold(
      (_) => emit(state.copyWith(status: FeedStatus.success)),
      (p) => emit(state.copyWith(
        status: FeedStatus.success,
        topics: [...state.topics, ...p.items],
        hasMore: p.items.length >= _limit,
        page: nextPage,
      )),
    );
  }
}
