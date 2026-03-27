import 'package:dotto/domain/subject_faculty.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_summary.freezed.dart';

@freezed
abstract class SubjectSummary with _$SubjectSummary {
  const factory SubjectSummary({
    required String id,
    required String name,
    required List<SubjectFaculty> faculties,
    // TODO
    // required TimetableSlot slot,
    // TODO
    // required bool isAddedToTimetable,
  }) = _SubjectSummary;
}
