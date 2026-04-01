import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_week_schedule_entry.freezed.dart';

@freezed
abstract class OneWeekScheduleEntry with _$OneWeekScheduleEntry {
  const factory OneWeekScheduleEntry({
    required String lessonId,
    required String title,
    required DateTime start,
    required int period,
    int? resourceId,
  }) = _OneWeekScheduleEntry;

  factory OneWeekScheduleEntry.fromJson(Map<String, Object?> json) {
    final lessonId = json['lessonId']?.toString();
    final title = json['title'] as String?;
    final startRaw = json['start'] as String?;
    final start = startRaw == null ? null : DateTime.tryParse(startRaw);
    final period = _toNullableInt(json['period']);
    if (lessonId == null || title == null || start == null || period == null) {
      throw const FormatException('Invalid one week schedule entry');
    }

    return OneWeekScheduleEntry(
      lessonId: lessonId,
      title: title,
      start: start,
      period: period,
      resourceId: _toNullableInt(json['resourceId']),
    );
  }

  static int? _toNullableInt(Object? value) {
    return switch (value) {
      int number => number,
      String text => int.tryParse(text),
      _ => null,
    };
  }
}
