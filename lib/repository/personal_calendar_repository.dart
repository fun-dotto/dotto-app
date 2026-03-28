import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/room_assignment_index.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personalCalendarRepositoryProvider = Provider<PersonalCalendarRepository>(
  (_) => PersonalCalendarRepositoryImpl(),
);

abstract class PersonalCalendarRepository {
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<TimetableItem> timetableItems,
    required Set<String> registeredSubjectIds,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required RoomAssignmentIndex roomAssignmentIndex,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  });
}

final class PersonalCalendarRepositoryImpl implements PersonalCalendarRepository {
  PersonalCalendarRepositoryImpl();

  @override
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<TimetableItem> timetableItems,
    required Set<String> registeredSubjectIds,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required RoomAssignmentIndex roomAssignmentIndex,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  }) {
    return targetDates.map((date) {
      final timetableDayOfWeek = DayOfWeek.fromDateTime(date);
      final items =
          timetableItems
              .where(
                (item) =>
                    item.slot != null &&
                    registeredSubjectIds.contains(item.subject.id) &&
                    item.slot!.dayOfWeek == timetableDayOfWeek,
              )
              .map((item) {
                final roomName = roomAssignmentIndex.roomName(
                  dayOfWeek: timetableDayOfWeek,
                  period: item.slot!.period,
                  title: item.subject.name,
                );
                return PersonalTimetableItem(
                  period: item.slot!.period,
                  subject: item.subject,
                  lectureStatus: LectureStatus.normal,
                  roomName: roomName ?? '',
                );
              })
              .toList()
            ..sort((a, b) => a.period.number.compareTo(b.period.number));

      final dateKey = _dateKey(date);
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
              roomName: roomAssignmentIndex.roomNameByTitle(override.lessonName) ?? '',
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
        }
      }

      items.sort((a, b) => a.period.number.compareTo(b.period.number));
      return PersonalTimetableDay(date: date, items: items, timetableDayOfWeek: timetableDayOfWeek);
    }).toList();
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
