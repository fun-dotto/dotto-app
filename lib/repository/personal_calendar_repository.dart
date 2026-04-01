import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/repository/model/one_week_schedule_entry.dart';

abstract class PersonalCalendarRepository {
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<OneWeekScheduleEntry> schedules,
    required Map<String, SubjectSummary> registeredSubjectsById,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  });
}

final class PersonalCalendarRepositoryImpl implements PersonalCalendarRepository {
  PersonalCalendarRepositoryImpl();

  @override
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<OneWeekScheduleEntry> schedules,
    required Map<String, SubjectSummary> registeredSubjectsById,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  }) {
    final targetDateKeys = targetDates.map(_dateKey).toSet();
    final scheduledItemsByDate = <String, Map<({Period period, String lessonName}), _ScheduledItem>>{};
    final roomNamesByLessonName = <String, Set<String>>{};

    for (final schedule in schedules) {
      final title = schedule.title.trim();
      if (title.isEmpty) {
        continue;
      }

      final subject = registeredSubjectsById[schedule.lessonId] ?? registeredSubjectsByName[title];
      if (subject == null) {
        continue;
      }

      final period = _periodFromNumber(schedule.period);
      if (period == null) {
        continue;
      }

      final date = DateTime(schedule.start.year, schedule.start.month, schedule.start.day);
      final dateKey = _dateKey(date);
      if (!targetDateKeys.contains(dateKey)) {
        continue;
      }

      final roomName = _resourceName(schedule.resourceId);
      if (roomName != null) {
        roomNamesByLessonName.putIfAbsent(subject.name, () => <String>{}).add(roomName);
      }

      final key = (period: period, lessonName: subject.name);
      final item = scheduledItemsByDate
          .putIfAbsent(dateKey, () => <({Period period, String lessonName}), _ScheduledItem>{})
          .putIfAbsent(key, () => _ScheduledItem(subject: subject, period: period, roomNames: <String>{}));
      if (roomName != null) {
        item.roomNames.add(roomName);
      }
    }

    return targetDates.map((date) {
      final timetableDayOfWeek = DayOfWeek.fromDateTime(date);
      final dateKey = _dateKey(date);
      final items =
          (scheduledItemsByDate[dateKey]?.values ?? const <_ScheduledItem>[])
              .map(
                (item) => PersonalTimetableItem(
                  period: item.period,
                  subject: item.subject,
                  lectureStatus: LectureStatus.normal,
                  roomName: (item.roomNames.toList()..sort()).join(', '),
                ),
              )
              .toList()
            ..sort((a, b) => a.period.number.compareTo(b.period.number));

      for (final override in cancelledByDate[dateKey] ?? const <LectureOverride>[]) {
        final targetIndex = items.indexWhere(
          (item) => item.period == override.period && item.subject.name == override.lessonName,
        );
        if (targetIndex >= 0) {
          items[targetIndex] = items[targetIndex].copyWith(lectureStatus: LectureStatus.cancelled);
          continue;
        }
        final subject = registeredSubjectsByName[override.lessonName];
        if (subject != null) {
          items.add(
            PersonalTimetableItem(
              period: override.period,
              subject: subject,
              lectureStatus: LectureStatus.cancelled,
              roomName: _roomNamesText(roomNamesByLessonName[override.lessonName]),
            ),
          );
        }
      }

      for (final override in madeUpByDate[dateKey] ?? const <LectureOverride>[]) {
        final targetIndex = items.indexWhere(
          (item) => item.period == override.period && item.subject.name == override.lessonName,
        );
        if (targetIndex >= 0) {
          items[targetIndex] = items[targetIndex].copyWith(lectureStatus: LectureStatus.madeUp);
          continue;
        }
        final subject = registeredSubjectsByName[override.lessonName];
        if (subject != null) {
          items.add(
            PersonalTimetableItem(
              period: override.period,
              subject: subject,
              lectureStatus: LectureStatus.madeUp,
              roomName: _roomNamesText(roomNamesByLessonName[override.lessonName]),
            ),
          );
        }
      }

      items.sort((a, b) => a.period.number.compareTo(b.period.number));
      return PersonalTimetableDay(date: date, items: items, timetableDayOfWeek: timetableDayOfWeek);
    }).toList();
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _roomNamesText(Set<String>? roomNames) {
    if (roomNames == null || roomNames.isEmpty) {
      return '';
    }
    return (roomNames.toList()..sort()).join(', ');
  }

  Period? _periodFromNumber(int number) {
    if (number < 1 || number > Period.values.length) {
      return null;
    }
    return Period.fromNumber(number);
  }

  String? _resourceName(int? resourceId) {
    if (resourceId == null) {
      return null;
    }
    return switch (resourceId) {
      1 => '講堂',
      2 => '大講義室',
      3 => '493',
      4 => '593',
      5 => '594',
      6 => '595',
      7 => 'R791',
      8 => '494C&D',
      9 => '495C&D',
      10 => '484',
      11 => '583',
      12 => '584',
      13 => '585',
      14 => 'R781',
      15 => 'R782',
      16 => '363',
      17 => '364',
      18 => '365',
      19 => '483',
      50 => 'アトリエ',
      51 => '体育館',
      90 => 'その他',
      99 => 'オンライン',
      _ => null,
    };
  }
}

final class _ScheduledItem {
  _ScheduledItem({required this.subject, required this.period, required this.roomNames});

  final SubjectSummary subject;
  final Period period;
  final Set<String> roomNames;
}
