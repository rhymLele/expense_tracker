import 'package:equatable/equatable.dart';

import '../../domain/entities/teacher_profile_entity.dart';

enum TeachersListStatus { initial, loading, success, failure, loadingMore }

class TeachersListState extends Equatable {
  final TeachersListStatus status;
  final List<TeacherProfileEntity> teachers;
  final String query;
  final String? subject;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  const TeachersListState({
    this.status = TeachersListStatus.initial,
    this.teachers = const [],
    this.query = '',
    this.subject,
    this.hasMore = true,
    this.page = 1,
    this.errorMessage,
  });

  TeachersListState copyWith({
    TeachersListStatus? status,
    List<TeacherProfileEntity>? teachers,
    String? query,
    String? subject,
    bool? hasMore,
    int? page,
    String? errorMessage,
  }) =>
      TeachersListState(
        status: status ?? this.status,
        teachers: teachers ?? this.teachers,
        query: query ?? this.query,
        subject: subject,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, teachers, query, subject, hasMore, page, errorMessage];
}
