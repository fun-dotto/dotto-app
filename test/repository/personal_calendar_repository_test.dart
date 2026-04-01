import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/repository/oneweek_schedule_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonalCalendarRepository', () {
    final repository = PersonalCalendarRepositoryImpl();
    final math = SubjectSummary(id: 'math', name: 'Math', faculties: const []);
    final english = SubjectSummary(id: 'english', name: 'English', faculties: const []);

    test('施設予約から日付ベースで時間割を構築できる', () {
      final schedules = [
        OneWeekScheduleEntry(lessonId: 'math', title: 'Math', start: DateTime(2026, 4, 7, 9), period: 1, resourceId: 2),
        OneWeekScheduleEntry(
          lessonId: 'math',
          title: 'Math',
          start: DateTime(2026, 4, 7, 9),
          period: 1,
          resourceId: 99,
        ),
        OneWeekScheduleEntry(
          lessonId: 'english',
          title: 'English',
          start: DateTime(2026, 4, 9, 10, 40),
          period: 2,
          resourceId: 11,
        ),
      ];

      final result = repository.getPersonalTimetableDays(
        targetDates: [DateTime(2026, 4, 7), DateTime(2026, 4, 8), DateTime(2026, 4, 9)],
        schedules: schedules,
        registeredSubjectsById: {math.id: math, english.id: english},
        registeredSubjectsByName: {math.name: math, english.name: english},
        cancelledByDate: const {},
        madeUpByDate: const {},
      );

      expect(result, hasLength(3));
      expect(result[0].timetableDayOfWeek, DayOfWeek.tuesday);
      expect(result[0].items, hasLength(1));
      expect(result[0].items.first.subject, math);
      expect(result[0].items.first.period, Period.first);
      expect(result[0].items.first.roomName, 'オンライン, 大講義室');
      expect(result[1].items, isEmpty);
      expect(result[2].items, hasLength(1));
      expect(result[2].items.first.subject, english);
      expect(result[2].items.first.period, Period.second);
      expect(result[2].items.first.roomName, '583');
    });

    test('休講補講は施設予約ベースの結果に上書きされる', () {
      final schedules = [
        OneWeekScheduleEntry(lessonId: 'math', title: 'Math', start: DateTime(2026, 4, 7, 9), period: 1, resourceId: 2),
      ];

      final result = repository.getPersonalTimetableDays(
        targetDates: [DateTime(2026, 4, 7), DateTime(2026, 4, 8)],
        schedules: schedules,
        registeredSubjectsById: {math.id: math, english.id: english},
        registeredSubjectsByName: {math.name: math, english.name: english},
        cancelledByDate: {
          '2026-4-7': [LectureOverride(lessonName: 'Math', period: Period.first)],
        },
        madeUpByDate: {
          '2026-4-8': [LectureOverride(lessonName: 'English', period: Period.third)],
        },
      );

      expect(result[0].items.single.lectureStatus, LectureStatus.cancelled);
      expect(result[1].items.single.subject, english);
      expect(result[1].items.single.period, Period.third);
      expect(result[1].items.single.lectureStatus, LectureStatus.madeUp);
    });
  });
}
