import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_summary.freezed.dart';

@freezed
abstract class SubjectSummary with _$SubjectSummary {
  const factory SubjectSummary({
    required String id,
    required String name,
    required List<String> faculties,
    required DayOfWeek dayOfWeek,
    required Period period,
    required bool isAddedToTimetable,
  }) = _SubjectSummary;

  static const List<SubjectSummary> stubs = [
    SubjectSummary(
      id: '1',
      name: '科目1',
      faculties: ['faculty1'],
      dayOfWeek: DayOfWeek.monday,
      period: Period.first,
      isAddedToTimetable: false,
    ),
    SubjectSummary(
      id: '2',
      name: '科目2',
      faculties: ['faculty2'],
      dayOfWeek: DayOfWeek.tuesday,
      period: Period.second,
      isAddedToTimetable: true,
    ),
    SubjectSummary(
      id: '3',
      name: '科目3',
      faculties: ['faculty3'],
      dayOfWeek: DayOfWeek.wednesday,
      period: Period.third,
      isAddedToTimetable: false,
    ),
    SubjectSummary(
      id: '4',
      name: '科目4',
      faculties: ['faculty4'],
      dayOfWeek: DayOfWeek.thursday,
      period: Period.fourth,
      isAddedToTimetable: true,
    ),
    SubjectSummary(
      id: '5',
      name: '科目5',
      faculties: ['faculty5'],
      dayOfWeek: DayOfWeek.friday,
      period: Period.fifth,
      isAddedToTimetable: false,
    ),
  ];
}
