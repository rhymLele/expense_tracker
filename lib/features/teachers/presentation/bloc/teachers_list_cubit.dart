import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_teachers_usecase.dart';
import 'teachers_list_state.dart';

class TeachersListCubit extends Cubit<TeachersListState> {
  final GetTeachersUseCase _getTeachersUseCase;
  static const _limit = 20;

  TeachersListCubit({required GetTeachersUseCase getTeachersUseCase})
      : _getTeachersUseCase = getTeachersUseCase,
        super(const TeachersListState());

  Future<void> load() async {
    if (state.status == TeachersListStatus.loading) return;
    emit(state.copyWith(status: TeachersListStatus.loading, teachers: [], page: 1));
    await _fetch(page: 1);
  }

  Future<void> search(String query) async {
    emit(state.copyWith(
      query: query,
      status: TeachersListStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(page: 1);
  }

  Future<void> filterBySubject(String? subject) async {
    emit(state.copyWith(
      subject: subject,
      status: TeachersListStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(page: 1);
  }

  Future<void> loadMore() async {
    if (state.status == TeachersListStatus.loadingMore || !state.hasMore) return;
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

  Future<void> _fetch({required int page}) async {
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
