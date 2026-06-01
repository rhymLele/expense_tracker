import 'package:equatable/equatable.dart';

class FollowState extends Equatable {
  final Set<String> followedIds;
  final bool isLoaded;
  final Set<String> pending; // optimistic in-flight toggles

  const FollowState({
    this.followedIds = const {},
    this.isLoaded = false,
    this.pending = const {},
  });

  bool isFollowing(String teacherId) => followedIds.contains(teacherId);
  bool isPending(String teacherId) => pending.contains(teacherId);

  FollowState copyWith({
    Set<String>? followedIds,
    bool? isLoaded,
    Set<String>? pending,
  }) =>
      FollowState(
        followedIds: followedIds ?? this.followedIds,
        isLoaded: isLoaded ?? this.isLoaded,
        pending: pending ?? this.pending,
      );

  @override
  List<Object?> get props => [followedIds, isLoaded, pending];
}
