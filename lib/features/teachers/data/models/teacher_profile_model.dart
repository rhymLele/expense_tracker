import '../../domain/entities/teacher_profile_entity.dart';

class TeacherProfileModel extends TeacherProfileEntity {
  const TeacherProfileModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userAvatarUrl,
    required super.subjects,
    required super.teachingMode,
    required super.rating,
    required super.reviewCount,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final rawSubjects = json['subjects'];
    final subjects = rawSubjects is List
        ? rawSubjects.cast<String>()
        : (rawSubjects as String?)?.split(',').where((s) => s.isNotEmpty).toList() ?? [];

    return TeacherProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: user['name'] as String? ?? '',
      userAvatarUrl: user['avatarUrl'] as String?,
      subjects: subjects,
      teachingMode: json['teachingMode'] as String? ?? 'online',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }
}
