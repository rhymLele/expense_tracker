import 'dart:developer' as dev;

import '../../domain/entities/enrollment_entity.dart';
import '../../domain/entities/today_task_entity.dart';

class EnrollmentModel extends EnrollmentEntity {
  const EnrollmentModel({
    required super.id,
    required super.userId,
    required super.roadmapId,
    required super.currentDay,
    required super.streak,
    super.lastCompletedDate,
    super.completedAt,
    required super.journeyTitle,
    required super.journeyTotalDays,
    super.status,
    super.todayTasks,
    super.dayTitles,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    try {
      final nested =
          (json['roadmap'] ?? json['journey']) as Map<String, dynamic>? ?? {};

      final roadmapId =
          _str(json['roadmapId']) ?? _str(json['journeyId']) ?? '';

      final currentDayIndex = json['currentDayIndex'] as int?;
      final currentDay = currentDayIndex != null
          ? currentDayIndex + 1
          : (json['currentDay'] as int? ?? 1);

      final title = _str(nested['title']) ?? '';
      final totalDays =
          (nested['limitTime'] as int?) ?? (nested['totalDays'] as int?) ?? 0;

      // Parse days array from roadmap (present in getActive response)
      final rawDays = nested['days'] as List? ?? [];
      final dayTitles = rawDays
          .map((d) => _str((d as Map<String, dynamic>)['title']) ?? '')
          .toList();

      // Today's tasks = roadmap.days[currentDayIndex].tasks
      final todayIndex = currentDayIndex ?? (currentDay - 1);
      List<TodayTaskEntity> todayTasks = [];
      if (rawDays.isNotEmpty && todayIndex < rawDays.length) {
        final todayDay = rawDays[todayIndex] as Map<String, dynamic>;
        final rawTasks = todayDay['tasks'] as List? ?? [];
        todayTasks = rawTasks.asMap().entries.map((e) {
          final t = e.value as Map<String, dynamic>;
          final meta = t['contentMetadata'] as Map<String, dynamic>? ?? {};
          return TodayTaskEntity(
            id: _str(t['id']) ?? '',
            title: _str(meta['title']) ??
                _str(meta['prompt']) ??
                _str(t['taskType']) ??
                'Bài tập ${e.key + 1}',
            taskType: _str(t['taskType']) ?? 'quiz',
            required: t['required'] as bool? ?? true,
            order: t['order'] as int? ?? e.key,
          );
        }).toList();
      }

      return EnrollmentModel(
        id: _str(json['id']) ?? '',
        userId: _str(json['userId']) ?? '',
        roadmapId: roadmapId,
        currentDay: currentDay,
        streak: json['streak'] as int? ?? 0,
        lastCompletedDate: _str(json['lastCompletedDate']),
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'].toString())
            : null,
        journeyTitle: title,
        journeyTotalDays: totalDays,
        status: _str(json['status']) ?? 'active',
        todayTasks: todayTasks,
        dayTitles: dayTitles,
      );
    } catch (e, st) {
      dev.log(
        'EnrollmentModel.fromJson error: $e\njson keys: ${json.keys.toList()}',
        stackTrace: st,
        name: 'Enrollment',
      );
      return EnrollmentModel(
        id: _str(json['id']) ?? '',
        userId: '',
        roadmapId: '',
        currentDay: 1,
        streak: 0,
        journeyTitle: 'Lộ trình',
        journeyTotalDays: 0,
      );
    }
  }

  static String? _str(dynamic v) => v == null ? null : v.toString();
}
