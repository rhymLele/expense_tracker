import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/follow_teacher_usecase.dart';
import '../../domain/usecases/get_following_usecase.dart';
import '../../domain/usecases/unfollow_teacher_usecase.dart';
import 'follow_state.dart';

class FollowCubit extends Cubit<FollowState> {
  final GetFollowingUseCase _getFollowing;
  final FollowTeacherUseCase _follow;
  final UnfollowTeacherUseCase _unfollow;

  FollowCubit({
    required GetFollowingUseCase getFollowing,
    required FollowTeacherUseCase follow,
    required UnfollowTeacherUseCase unfollow,
  })  : _getFollowing = getFollowing,
        _follow = follow,
        _unfollow = unfollow,
        super(const FollowState());

  Future<void> load() async {
    final result = await _getFollowing();
    result.fold(
      (_) {},
      (teachers) => emit(state.copyWith(
        followedIds: teachers.map((t) => t.userId).toSet(),
        isLoaded: true,
      )),
    );
  }

  Future<void> toggle(String teacherId) async {
    if (state.isPending(teacherId)) return;

    final wasFollowing = state.isFollowing(teacherId);
    final newIds = Set<String>.from(state.followedIds);
    if (wasFollowing) {
      newIds.remove(teacherId);
    } else {
      newIds.add(teacherId);
    }
    final newPending = Set<String>.from(state.pending)..add(teacherId);
    emit(state.copyWith(followedIds: newIds, pending: newPending));

    final result = wasFollowing
        ? await _unfollow(teacherId)
        : await _follow(teacherId);

    result.fold(
      (_) {
        // Revert on failure
        final reverted = Set<String>.from(state.followedIds);
        if (wasFollowing) {
          reverted.add(teacherId);
        } else {
          reverted.remove(teacherId);
        }
        final clearedPending = Set<String>.from(state.pending)
          ..remove(teacherId);
        emit(state.copyWith(
            followedIds: reverted, pending: clearedPending));
      },
      (_) {
        final clearedPending = Set<String>.from(state.pending)
          ..remove(teacherId);
        emit(state.copyWith(pending: clearedPending));
      },
    );
  }
}
