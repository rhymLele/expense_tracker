import '../../../../core/base/base_state.dart';
import '../../domain/entities/teacher_profile_entity.dart';
import '../../../topics/domain/entities/topic_entity.dart';

class TeacherProfileState extends BaseState<TeacherProfileState> {
  final TeacherProfileEntity? teacher;
  final List<TopicEntity> topics;
  final bool isFollowing;
  final bool isFollowLoading;

  const TeacherProfileState({
    super.status,
    super.error,
    this.teacher,
    this.topics = const [],
    this.isFollowing = false,
    this.isFollowLoading = false,
  });

  TeacherProfileState copyWith({
    ViewStatus? status,
    TeacherProfileEntity? teacher,
    List<TopicEntity>? topics,
    bool? isFollowing,
    bool? isFollowLoading,
    String? error,
  }) =>
      TeacherProfileState(
        status: status ?? this.status,
        teacher: teacher ?? this.teacher,
        topics: topics ?? this.topics,
        isFollowing: isFollowing ?? this.isFollowing,
        isFollowLoading: isFollowLoading ?? this.isFollowLoading,
        error: error,
      );

  @override
  TeacherProfileState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props =>
      [status, error, teacher, topics, isFollowing, isFollowLoading];
}
