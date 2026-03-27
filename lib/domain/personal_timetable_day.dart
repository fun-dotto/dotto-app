import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_timetable_day.freezed.dart';

@freezed
abstract class PersonalTimetableDay with _$PersonalTimetableDay {
  const factory PersonalTimetableDay({
    required DateTime date,
    required List<PersonalTimetableItem> items,
    // 時間割上の曜日
    //
    // 振替授業日の場合、dateフィールドの曜日とは異なる
    required DayOfWeek timetableDayOfWeek,
  }) = _PersonalTimetableDay;
}
