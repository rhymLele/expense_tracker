import 'package:equatable/equatable.dart';

abstract class TeacherProfileEvent extends Equatable {
  const TeacherProfileEvent();
  @override
  List<Object?> get props => [];
}

class TeacherProfileLoadRequested extends TeacherProfileEvent {
  final String userId;
  const TeacherProfileLoadRequested(this.userId);
  @override
  List<Object?> get props => [userId];
}

class TeacherProfileFollowToggled extends TeacherProfileEvent {
  const TeacherProfileFollowToggled();
}
