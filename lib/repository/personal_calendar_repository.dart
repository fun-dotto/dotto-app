import 'package:built_collection/built_collection.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/faculty.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:openapi/openapi.dart' hide SubjectFaculty, SubjectSummary;

abstract class PersonalCalendarRepository {
  Future<List<PersonalTimetableDay>> getPersonalTimetableDays({required List<DateTime> targetDates});
}

final class PersonalCalendarRepositoryImpl implements PersonalCalendarRepository {
  PersonalCalendarRepositoryImpl(this.apiClient);

  final Openapi apiClient;

  @override
  Future<List<PersonalTimetableDay>> getPersonalTimetableDays({required List<DateTime> targetDates}) async {
    try {
      final api = apiClient.getPersonalCalendarItemsApi();
      final dates = BuiltList<Date>(targetDates.map((d) => Date(d.year, d.month, d.day)));
      final response = await api.personalCalendarItemsV1List(dates: dates);
      if (response.statusCode != 200) {
        throw Exception('Failed to get personal calendar items: status ${response.statusCode}');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to get personal calendar items');
      }

      final itemsByDate = <String, List<PersonalTimetableItem>>{};
      for (final item in data.personalCalendarItems) {
        final dateKey = '${item.date.year}-${item.date.month}-${item.date.day}';
        final itemDate = DateTime(item.date.year, item.date.month, item.date.day);
        final semester = toSemester(item.subject.semester);

        // その日付に該当しない学期の授業は除外する
        if (!semester.isActiveAt(itemDate)) {
          continue;
        }

        final timetableItem = PersonalTimetableItem(
          period: toPeriod(item.period),
          subject: SubjectSummary(
            id: item.subject.id,
            name: item.subject.name,
            faculties: item.subject.faculties
                .map(
                  (e) => SubjectFaculty(
                    faculty: Faculty(id: e.faculty.id, name: e.faculty.name, email: e.faculty.email),
                    isPrimary: e.isPrimary,
                  ),
                )
                .toList(),
            semester: semester,
          ),
          lectureStatus: toLectureStatus(item.status),
          roomName: item.rooms.map((r) => r.name).join(', '),
        );
        itemsByDate.putIfAbsent(dateKey, () => <PersonalTimetableItem>[]).add(timetableItem);
      }

      return targetDates.map((date) {
        final dateKey = '${date.year}-${date.month}-${date.day}';
        final items = itemsByDate[dateKey] ?? <PersonalTimetableItem>[];
        items.sort((a, b) => a.period.number.compareTo(b.period.number));
        return PersonalTimetableDay(date: date, items: items, timetableDayOfWeek: DayOfWeek.fromDateTime(date));
      }).toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @visibleForTesting
  static Period toPeriod(DottoFoundationV1Period period) {
    return switch (period) {
      DottoFoundationV1Period.period1 => Period.first,
      DottoFoundationV1Period.period2 => Period.second,
      DottoFoundationV1Period.period3 => Period.third,
      DottoFoundationV1Period.period4 => Period.fourth,
      DottoFoundationV1Period.period5 => Period.fifth,
      DottoFoundationV1Period.period6 => Period.sixth,
      _ => throw UnsupportedError('Unsupported DottoFoundationV1Period: $period'),
    };
  }

  @visibleForTesting
  static LectureStatus toLectureStatus(DottoFoundationV1PersonalCalendarItemStatus status) {
    return switch (status) {
      DottoFoundationV1PersonalCalendarItemStatus.normal => LectureStatus.normal,
      DottoFoundationV1PersonalCalendarItemStatus.cancelled => LectureStatus.cancelled,
      DottoFoundationV1PersonalCalendarItemStatus.makeup => LectureStatus.madeUp,
      DottoFoundationV1PersonalCalendarItemStatus.roomChanged => LectureStatus.roomChanged,
      // TODO: API側でstatusの値が増えたときに例外を投げるようにするため、デフォルトはnormalにしておく
      DottoFoundationV1PersonalCalendarItemStatus() => LectureStatus.normal,
    };
  }

  @visibleForTesting
  static Semester toSemester(DottoFoundationV1CourseSemester semester) {
    try {
      return Semester.values.byName(semester.name);
    } on StateError {
      throw UnsupportedError('Unsupported DottoFoundationV1CourseSemester: $semester');
    }
  }
}
