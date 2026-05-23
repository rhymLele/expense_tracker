import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_teachers_usecase.dart';
import 'teachers_list_event.dart';
import 'teachers_list_state.dart';

class TeachersListBloc extends Bloc<TeachersListEvent, TeachersListState> {
  final GetTeachersUseCase _getTeachersUseCase;
  static const _limit = 20;

  TeachersListBloc({required GetTeachersUseCase getTeachersUseCase})
      : _getTeachersUseCase = getTeachersUseCase,
        super(const TeachersListState()) {
    on<TeachersListLoadRequested>(_onLoad);
    on<TeachersListSearchChanged>(_onSearchChanged);
    on<TeachersListSubjectFiltered>(_onSubjectFiltered);
    on<TeachersListLoadMoreRequested>(_onLoadMore);
  }

  Future<void> _onLoad(
    TeachersListLoadRequested event,
    Emitter<TeachersListState> emit,
  ) async {
    if (state.status == TeachersListStatus.loading) return;
    emit(state.copyWith(
      status: TeachersListStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(emit, page: 1);
  }

  Future<void> _onSearchChanged(
    TeachersListSearchChanged event,
    Emitter<TeachersListState> emit,
  ) async {
    emit(state.copyWith(
      query: event.query,
      status: TeachersListStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(emit, page: 1);
  }

  Future<void> _onSubjectFiltered(
    TeachersListSubjectFiltered event,
    Emitter<TeachersListState> emit,
  ) async {
    emit(state.copyWith(
      subject: event.subject,
      status: TeachersListStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(emit, page: 1);
  }

  Future<void> _onLoadMore(
    TeachersListLoadMoreRequested event,
    Emitter<TeachersListState> emit,
  ) async {
    if (state.status == TeachersListStatus.loadingMore || !state.hasMore) {
      return;
    }
    emit(state.copyWith(status: TeachersListStatus.loadingMore));
    final nextPage = state.page + 1;
    final result = await _getTeachersUseCase(
      subject: state.subject,
      page: nextPage,
      limit: _limit,
    );
    result.fold(
      (_) => emit(state.copyWith(status: TeachersListStatus.success)),
      (p) => emit(state.copyWith(
        status: TeachersListStatus.success,
        teachers: [...state.teachers, ...p.items],
        hasMore: p.items.length >= _limit,
        page: nextPage,
      )),
    );
  }

  Future<void> _fetch(Emitter<TeachersListState> emit, {required int page}) async {
    final result = await _getTeachersUseCase(
      subject: state.subject,
      page: page,
      limit: _limit,
    );
    result.fold(
      (f) => emit(state.copyWith(
        status: TeachersListStatus.failure,
        errorMessage: f.message,
      )),
      (p) => emit(state.copyWith(
        status: TeachersListStatus.success,
        teachers: p.items,
        hasMore: p.items.length >= _limit,
        page: page,
      )),
    );
  }
}
