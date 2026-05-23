import 'package:equatable/equatable.dart';

import '../../domain/entities/enrollment_entity.dart';

enum EnrollmentsStatus { initial, loading, success, failure }

class EnrollmentsState extends Equatable {
  final EnrollmentsStatus status;
  final List<EnrollmentEntity> enrollments;
  final String? errorMessage;

  const EnrollmentsState({
    this.status = EnrollmentsStatus.initial,
    this.enrollments = const [],
    this.errorMessage,
  });

  EnrollmentsState copyWith({
    EnrollmentsStatus? status,
    List<EnrollmentEntity>? enrollments,
    String? errorMessage,
  }) =>
      EnrollmentsState(
        status: status ?? this.status,
        enrollments: enrollments ?? this.enrollments,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, enrollments, errorMessage];
}
