import 'package:equatable/equatable.dart';

import '../../domain/entities/teacher_profile_entity.dart';
import '../../../topics/domain/entities/topic_entity.dart';

enum TeacherProfileStatus { initial, loading, success, failure }

class TeacherProfileState extends Equatable {
  final TeacherProfileStatus status;
  final TeacherProfileEntity? teacher;
  final List<TopicEntity> topics;
  final bool isFollowing;
  final bool isFollowLoading;
  final String? errorMessage;

  const TeacherProfileState({
    this.status = TeacherProfileStatus.initial,
    this.teacher,
    this.topics = const [],
    this.isFollowing = false,
    this.isFollowLoading = false,
    this.errorMessage,
  });

  TeacherProfileState copyWith({
    TeacherProfileStatus? status,
    TeacherProfileEntity? teacher,
    List<TopicEntity>? topics,
    bool? isFollowing,
    bool? isFollowLoading,
    String? errorMessage,
  }) =>
      TeacherProfileState(
        status: status ?? this.status,
        teacher: teacher ?? this.teacher,
        topics: topics ?? this.topics,
        isFollowing: isFollowing ?? this.isFollowing,
        isFollowLoading: isFollowLoading ?? this.isFollowLoading,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, teacher, topics, isFollowing, isFollowLoading, errorMessage];
}
