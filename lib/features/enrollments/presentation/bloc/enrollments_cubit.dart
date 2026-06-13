import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_my_enrollments_usecase.dart';
import 'enrollments_state.dart';

class EnrollmentsCubit extends Cubit<EnrollmentsState> {
  final GetMyEnrollmentsUseCase _getMyEnrollmentsUseCase;

  EnrollmentsCubit({required GetMyEnrollmentsUseCase getMyEnrollmentsUseCase})
      : _getMyEnrollmentsUseCase = getMyEnrollmentsUseCase,
        super(const EnrollmentsState());

  Future<void> load() async {
    if (state.status == EnrollmentsStatus.loading) return;
    emit(state.copyWith(status: EnrollmentsStatus.loading));
    final result = await _getMyEnrollmentsUseCase();
    result.fold(
      (f) => emit(state.copyWith(
        status: EnrollmentsStatus.failure,
        errorMessage: f.message,
      )),
      (items) => emit(state.copyWith(
        status: EnrollmentsStatus.success,
        enrollments: items,
      )),
    );
  }

  Future<void> refresh() async {
    emit(state.copyWith(status: EnrollmentsStatus.loading));
    final result = await _getMyEnrollmentsUseCase();
    result.fold(
      (f) => emit(state.copyWith(
        status: EnrollmentsStatus.failure,
        errorMessage: f.message,
      )),
      (items) => emit(state.copyWith(
        status: EnrollmentsStatus.success,
        enrollments: items,
      )),
    );
  }
}
