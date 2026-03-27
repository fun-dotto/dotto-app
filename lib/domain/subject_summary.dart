import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_summary.freezed.dart';

@freezed
abstract class SubjectSummary with _$SubjectSummary {
  const factory SubjectSummary({
    required String id,
    required String name,
    required List<SubjectFaculty> faculties,
    // 科目検索画面で使用
    List<TimetableSlot>? slots,
    // 科目検索画面で使用
    bool? isAddedToTimetable,
  }) = _SubjectSummary;
}
