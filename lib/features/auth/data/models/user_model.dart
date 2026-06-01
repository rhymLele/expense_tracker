import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.bio,
    super.avatarUrl,
    super.role,
    super.onboardingStatus,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawOnboarding = json['onboardingStatus'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? 'student',
      onboardingStatus: rawOnboarding != null
          ? OnboardingStatus.fromJson(rawOnboarding)
          : const OnboardingStatus(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'bio': bio,
        'avatarUrl': avatarUrl,
        'role': role,
        'createdAt': createdAt.toIso8601String(),
      };
}
