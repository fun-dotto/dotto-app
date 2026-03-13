import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/faculty.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_summary.freezed.dart';

@freezed
abstract class SubjectSummary with _$SubjectSummary {
  const factory SubjectSummary({
    required String id,
    required String name,
    required List<SubjectFaculty> faculties,
    required DayOfWeek dayOfWeek,
    required Period period,
    required bool isAddedToTimetable,
  }) = _SubjectSummary;
}

const List<SubjectSummary> _stubs = [
  SubjectSummary(
    id: '1',
    name: '科目1',
    faculties: [
      SubjectFaculty(
        faculty: Faculty(id: '1', name: '教員1', email: 'faculty1@example.com'),
        isPrimary: true,
      ),
    ],
    dayOfWeek: DayOfWeek.monday,
    period: Period.first,
    isAddedToTimetable: false,
  ),
  SubjectSummary(
    id: '2',
    name: '科目2',
    faculties: [
      SubjectFaculty(
        faculty: Faculty(id: '2', name: '教員2', email: 'faculty2@example.com'),
        isPrimary: false,
      ),
    ],
    dayOfWeek: DayOfWeek.tuesday,
    period: Period.second,
    isAddedToTimetable: true,
  ),
  SubjectSummary(
    id: '3',
    name: '科目3',
    faculties: [
      SubjectFaculty(
        faculty: Faculty(id: '3', name: '教員3', email: 'faculty3@example.com'),
        isPrimary: false,
      ),
    ],
    dayOfWeek: DayOfWeek.wednesday,
    period: Period.third,
    isAddedToTimetable: false,
  ),
  SubjectSummary(
    id: '4',
    name: '科目4',
    faculties: [
      SubjectFaculty(
        faculty: Faculty(id: '4', name: '教員4', email: 'faculty4@example.com'),
        isPrimary: false,
      ),
    ],
    dayOfWeek: DayOfWeek.thursday,
    period: Period.fourth,
    isAddedToTimetable: true,
  ),
  SubjectSummary(
    id: '5',
    name: '科目5',
    faculties: [
      SubjectFaculty(
        faculty: Faculty(id: '5', name: '教員5', email: 'faculty5@example.com'),
        isPrimary: false,
      ),
    ],
    dayOfWeek: DayOfWeek.friday,
    period: Period.fifth,
    isAddedToTimetable: false,
  ),
];
