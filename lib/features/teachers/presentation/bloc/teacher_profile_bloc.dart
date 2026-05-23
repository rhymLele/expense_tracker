import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_teacher_profile_usecase.dart';
import '../../../follows/domain/usecases/follow_teacher_usecase.dart';
import '../../../follows/domain/usecases/unfollow_teacher_usecase.dart';
import '../../../topics/domain/usecases/get_topics_by_teacher_usecase.dart';
import 'teacher_profile_event.dart';
import 'teacher_profile_state.dart';

class TeacherProfileBloc
    extends Bloc<TeacherProfileEvent, TeacherProfileState> {
  final GetTeacherProfileUseCase _getTeacherProfile;
  final GetTopicsByTeacherUseCase _getTopicsByTeacher;
  final FollowTeacherUseCase _follow;
  final UnfollowTeacherUseCase _unfollow;

  TeacherProfileBloc({
    required GetTeacherProfileUseCase getTeacherProfile,
    required GetTopicsByTeacherUseCase getTopicsByTeacher,
    required FollowTeacherUseCase follow,
    required UnfollowTeacherUseCase unfollow,
  })  : _getTeacherProfile = getTeacherProfile,
        _getTopicsByTeacher = getTopicsByTeacher,
        _follow = follow,
        _unfollow = unfollow,
        super(const TeacherProfileState()) {
    on<TeacherProfileLoadRequested>(_onLoad);
    on<TeacherProfileFollowToggled>(_onFollowToggled);
  }

  Future<void> _onLoad(
    TeacherProfileLoadRequested event,
    Emitter<TeacherProfileState> emit,
  ) async {
    emit(state.copyWith(status: TeacherProfileStatus.loading));

    final profileResult = await _getTeacherProfile(event.userId);
    await profileResult.fold(
      (f) async => emit(state.copyWith(
        status: TeacherProfileStatus.failure,
        errorMessage: f.message,
      )),
      (teacher) async {
        final topicsResult =
            await _getTopicsByTeacher(teacher.userId, page: 1, limit: 20);
        topicsResult.fold(
          (_) => emit(state.copyWith(
            status: TeacherProfileStatus.success,
            teacher: teacher,
          )),
          (p) => emit(state.copyWith(
            status: TeacherProfileStatus.success,
            teacher: teacher,
            topics: p.items,
          )),
        );
      },
    );
  }

  Future<void> _onFollowToggled(
    TeacherProfileFollowToggled event,
    Emitter<TeacherProfileState> emit,
  ) async {
    if (state.teacher == null || state.isFollowLoading) return;

    final wasFollowing = state.isFollowing;
    // Optimistic update
    emit(state.copyWith(
      isFollowing: !wasFollowing,
      isFollowLoading: true,
    ));

    final result = wasFollowing
        ? await _unfollow(state.teacher!.userId)
        : await _follow(state.teacher!.userId);

    result.fold(
      (_) => emit(state.copyWith(
        isFollowing: wasFollowing,
        isFollowLoading: false,
      )),
      (_) => emit(state.copyWith(isFollowLoading: false)),
    );
  }
}
