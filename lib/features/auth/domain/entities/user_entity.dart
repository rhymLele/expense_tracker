import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.bio,
    this.avatarUrl,
    this.role = 'student',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, bio, avatarUrl, role, createdAt];
}
