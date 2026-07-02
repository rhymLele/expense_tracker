import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/usecases/get_teachers_usecase.dart';
import 'teachers_list_state.dart';

class TeachersListCubit extends LoadCubit<TeachersListState> {
  final GetTeachersUseCase _getTeachersUseCase;
  static const _limit = 20;

  TeachersListCubit({required GetTeachersUseCase getTeachersUseCase})
      : _getTeachersUseCase = getTeachersUseCase,
        super(const TeachersListState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: ViewStatus.loading, teachers: [], page: 1));
    await _fetch(page: 1);
  }

  Future<void> search(String query) async {
    emit(state.copyWith(
      query: query,
      status: ViewStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(page: 1);
  }

  Future<void> filterBySubject(String? subject) async {
    emit(state.copyWith(
      subject: subject,
      status: ViewStatus.loading,
      teachers: [],
      page: 1,
    ));
    await _fetch(page: 1);
  }

  Future<void> loadMore() async {
    if (state.status.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(status: ViewStatus.loadingMore));
    final nextPage = state.page + 1;
    final result = await _getTeachersUseCase(
      subject: state.subject,
      page: nextPage,
      limit: _limit,
    );
    result.fold(
      (_) => emit(state.copyWith(status: ViewStatus.success)),
      (p) => emit(state.copyWith(
        status: ViewStatus.success,
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
      (f) => emit(state.copyWith(status: ViewStatus.failure, error: f.message)),
      (p) => emit(state.copyWith(
        status: ViewStatus.success,
        teachers: p.items,
        hasMore: p.items.length >= _limit,
        page: page,
      )),
    );
  }
}
