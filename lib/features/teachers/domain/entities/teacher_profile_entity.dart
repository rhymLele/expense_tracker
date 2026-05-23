import 'package:equatable/equatable.dart';

class TeacherProfileEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final List<String> subjects;
  final String teachingMode;
  final double rating;
  final int reviewCount;

  const TeacherProfileEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.subjects,
    required this.teachingMode,
    required this.rating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [id, userId, subjects, teachingMode, rating, reviewCount];
}
