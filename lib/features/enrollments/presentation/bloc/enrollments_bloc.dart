import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_my_enrollments_usecase.dart';
import 'enrollments_event.dart';
import 'enrollments_state.dart';

class EnrollmentsBloc extends Bloc<EnrollmentsEvent, EnrollmentsState> {
  final GetMyEnrollmentsUseCase _getMyEnrollmentsUseCase;

  EnrollmentsBloc({required GetMyEnrollmentsUseCase getMyEnrollmentsUseCase})
      : _getMyEnrollmentsUseCase = getMyEnrollmentsUseCase,
        super(const EnrollmentsState()) {
    on<EnrollmentsLoadRequested>(_onLoad);
    on<EnrollmentsRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    EnrollmentsLoadRequested event,
    Emitter<EnrollmentsState> emit,
  ) async {
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

  Future<void> _onRefresh(
    EnrollmentsRefreshRequested event,
    Emitter<EnrollmentsState> emit,
  ) async {
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
