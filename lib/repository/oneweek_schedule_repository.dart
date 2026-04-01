import 'package:dotto/helper/file_helper.dart';

abstract class OneWeekScheduleRepository {
  Future<List<OneWeekScheduleEntry>> getSchedules();
}

final class OneWeekScheduleRepositoryImpl implements OneWeekScheduleRepository {
  OneWeekScheduleRepositoryImpl();

  @override
  Future<List<OneWeekScheduleEntry>> getSchedules() async {
    try {
      final data = await FileHelper.getJSONData('map/oneweek_schedule.json');
      return data
          .whereType<Map<String, dynamic>>()
          .map(OneWeekScheduleEntry.fromJson)
          .whereType<OneWeekScheduleEntry>()
          .toList();
    } on Exception {
      return const <OneWeekScheduleEntry>[];
    }
  }
}

final class OneWeekScheduleEntry {
  const OneWeekScheduleEntry({
    required this.lessonId,
    required this.title,
    required this.start,
    required this.period,
    required this.resourceId,
  });

  final String lessonId;
  final String title;
  final DateTime start;
  final int period;
  final int? resourceId;

  static OneWeekScheduleEntry? fromJson(Map<String, dynamic> json) {
    final lessonId = json['lessonId']?.toString();
    final title = json['title'] as String?;
    final startRaw = json['start'] as String?;
    final period = _toInt(json['period']);
    final start = startRaw == null ? null : DateTime.tryParse(startRaw);
    if (lessonId == null || title == null || start == null || period == null) {
      return null;
    }

    return OneWeekScheduleEntry(
      lessonId: lessonId,
      title: title,
      start: start,
      period: period,
      resourceId: _toInt(json['resourceId']),
    );
  }

  static int? _toInt(Object? value) {
    return switch (value) {
      int number => number,
      String text => int.tryParse(text),
      _ => null,
    };
  }
}
