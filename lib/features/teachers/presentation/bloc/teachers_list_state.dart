import '../../../../core/base/base_state.dart';
import '../../domain/entities/teacher_profile_entity.dart';

class TeachersListState extends BaseState<TeachersListState> {
  final List<TeacherProfileEntity> teachers;
  final String query;
  final String? subject;
  final bool hasMore;
  final int page;

  const TeachersListState({
    super.status,
    super.error,
    this.teachers = const [],
    this.query = '',
    this.subject,
    this.hasMore = true,
    this.page = 1,
  });

  TeachersListState copyWith({
    ViewStatus? status,
    List<TeacherProfileEntity>? teachers,
    String? query,
    String? subject,
    bool? hasMore,
    int? page,
    String? error,
  }) =>
      TeachersListState(
        status: status ?? this.status,
        teachers: teachers ?? this.teachers,
        query: query ?? this.query,
        subject: subject,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
      );

  @override
  TeachersListState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props =>
      [status, error, teachers, query, subject, hasMore, page];
}
