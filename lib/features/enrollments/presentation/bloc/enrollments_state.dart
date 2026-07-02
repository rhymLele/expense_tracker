import '../../../../core/base/base_state.dart';
import '../../domain/entities/enrollment_entity.dart';

class EnrollmentsState extends BaseState<EnrollmentsState> {
  final List<EnrollmentEntity> enrollments;

  const EnrollmentsState({
    super.status,
    super.error,
    this.enrollments = const [],
  });

  EnrollmentsState copyWith({
    ViewStatus? status,
    List<EnrollmentEntity>? enrollments,
    String? error,
  }) =>
      EnrollmentsState(
        status: status ?? this.status,
        enrollments: enrollments ?? this.enrollments,
        error: error,
      );

  @override
  EnrollmentsState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [status, error, enrollments];
}
