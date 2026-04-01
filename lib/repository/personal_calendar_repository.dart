import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/period.dart';

abstract class PersonalCalendarRepository {
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<Room> rooms,
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
    required List<Room> rooms,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  }) {
    final targetDateKeys = targetDates.map(_dateKey).toSet();
    final scheduledItemsByDate = <String, Map<({Period period, String lessonName}), _ScheduledItem>>{};
    final roomNamesByTitle = <String, Set<String>>{};

    for (final room in rooms) {
      final roomName = room.shortName.trim();
      if (roomName.isEmpty) {
        continue;
      }

      for (final schedule in room.schedules) {
        final title = schedule.title.trim();
        if (title.isEmpty) {
          continue;
        }

        final subject = registeredSubjectsByName[title];
        if (subject == null) {
          continue;
        }

        roomNamesByTitle.putIfAbsent(title, () => <String>{}).add(roomName);

        final date = DateTime(schedule.beginDatetime.year, schedule.beginDatetime.month, schedule.beginDatetime.day);
        final dateKey = _dateKey(date);
        if (!targetDateKeys.contains(dateKey)) {
          continue;
        }

        final period = _periodFromDateTime(schedule.beginDatetime);
        if (period == null) {
          continue;
        }

        final key = (period: period, lessonName: title);
        final item = scheduledItemsByDate
            .putIfAbsent(dateKey, () => <({Period period, String lessonName}), _ScheduledItem>{})
            .putIfAbsent(key, () => _ScheduledItem(subject: subject, period: period, roomNames: <String>{}));
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
              roomName: _roomNamesText(roomNamesByTitle[override.lessonName]),
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
              roomName: _roomNamesText(roomNamesByTitle[override.lessonName]),
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

  Period? _periodFromDateTime(DateTime dateTime) {
    final minutes = dateTime.hour * 60 + dateTime.minute;
    for (final period in Period.values) {
      final startMinutes = period.startTime.hour * 60 + period.startTime.minute;
      final endMinutes = period.endTime.hour * 60 + period.endTime.minute;
      if (minutes >= startMinutes && minutes <= endMinutes) {
        return period;
      }
    }
    return null;
  }
}

final class _ScheduledItem {
  _ScheduledItem({required this.subject, required this.period, required this.roomNames});

  final SubjectSummary subject;
  final Period period;
  final Set<String> roomNames;
}
