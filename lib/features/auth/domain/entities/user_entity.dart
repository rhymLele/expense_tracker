import 'package:equatable/equatable.dart';

class OnboardingStatus extends Equatable {
  final bool isStudentTourDone;
  final bool isTeacherTourDone;

  const OnboardingStatus({
    this.isStudentTourDone = false,
    this.isTeacherTourDone = false,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) => OnboardingStatus(
        isStudentTourDone: json['isStudentTourDone'] as bool? ?? false,
        isTeacherTourDone: json['isTeacherTourDone'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [isStudentTourDone, isTeacherTourDone];
}

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final String role;
  final OnboardingStatus onboardingStatus;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.bio,
    this.avatarUrl,
    this.role = 'student',
    this.onboardingStatus = const OnboardingStatus(),
    required this.createdAt,
  });

  bool get isTeacher => role == 'teacher';
  bool get needsTour =>
      (isTeacher && !onboardingStatus.isTeacherTourDone) ||
      (!isTeacher && !onboardingStatus.isStudentTourDone);

  @override
  List<Object?> get props =>
      [id, email, name, bio, avatarUrl, role, onboardingStatus, createdAt];
}
