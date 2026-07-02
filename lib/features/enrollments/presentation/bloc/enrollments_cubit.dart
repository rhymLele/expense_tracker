import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../domain/usecases/get_my_enrollments_usecase.dart';
import 'enrollments_state.dart';

class EnrollmentsCubit extends LoadCubit<EnrollmentsState> {
  final GetMyEnrollmentsUseCase _getMyEnrollmentsUseCase;

  EnrollmentsCubit({required GetMyEnrollmentsUseCase getMyEnrollmentsUseCase})
      : _getMyEnrollmentsUseCase = getMyEnrollmentsUseCase,
        super(const EnrollmentsState());

  @override
  Future<void> fetchData() => load();

  Future<void> load() async {
    if (state.status.isLoading) return;
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getMyEnrollmentsUseCase();
    result.fold(
      (f) => emit(state.copyWith(status: ViewStatus.failure, error: f.message)),
      (items) => emit(state.copyWith(
        status: ViewStatus.success,
        enrollments: items,
      )),
    );
  }

  Future<void> refresh() => load();
}
