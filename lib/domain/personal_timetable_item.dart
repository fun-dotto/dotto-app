import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_timetable_item.freezed.dart';

@freezed
abstract class PersonalTimetableItem with _$PersonalTimetableItem {
  const factory PersonalTimetableItem({
    required Period period,
    required SubjectSummary subject,
    required LectureStatus lectureStatus,
    required String roomName,
  }) = _PersonalTimetableItem;
}
