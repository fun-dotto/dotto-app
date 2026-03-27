import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable_item.freezed.dart';

@freezed
abstract class TimetableItem with _$TimetableItem {
  const factory TimetableItem({
    required String id,
    required SubjectSummary subject,
    required TimetableSlot? slot,
    // 履修登録画面で使用
    bool? isAddedToTimetable,
  }) = _TimetableItem;
}
