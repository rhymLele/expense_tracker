import 'package:equatable/equatable.dart';

/// Represents one task in today's learning checklist.
class TodayTaskEntity extends Equatable {
  final String id;
  final String title;
  final String taskType; // quiz | essay | recording
  final bool required;
  final int order;

  const TodayTaskEntity({
    required this.id,
    required this.title,
    required this.taskType,
    this.required = true,
    this.order = 0,
  });

  /// Human-readable chip label in Vietnamese.
  String get typeLabel => switch (taskType) {
        'quiz' => 'Trắc nghiệm',
        'essay' => 'Viết luận',
        'recording' => 'Ghi âm',
        'pronunciation' => 'Phát âm',
        'reading' => 'Đọc hiểu',
        'writing' => 'Viết',
        _ => taskType,
      };

  @override
  List<Object?> get props => [id, taskType, required, order];
}
