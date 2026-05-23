import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String teacherId;
  final String type;
  final String title;
  final String? description;
  final Map<String, dynamic> config;
  final DateTime createdAt;

  const ExerciseEntity({
    required this.id,
    required this.teacherId,
    required this.type,
    required this.title,
    this.description,
    required this.config,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, teacherId, type, title, createdAt];
}
