import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/helper/file_helper.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/room_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_reducer.g.dart';

@riverpod
final class CourseReducer extends _$CourseReducer {
  @override
  Future<CourseState> build() async {
    return _createCourseState();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_createCourseState);
  }

  Future<CourseState> _createCourseState() async {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
    final timetableRepository = TimetableRepositoryImpl(apiClient);
    final roomRepository = ref.read(roomRepositoryProvider);

    final (courseRegistrations, timetableItems, roomAssignmentIndex) = await (
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
      timetableRepository.getTimetableItems(Semester.values),
      roomRepository.getRoomAssignmentIndex(),
    ).wait;

    final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
    final registeredSubjectsByName = <String, SubjectSummary>{
      for (final registration in courseRegistrations) registration.subject.name: registration.subject,
    };
    final cancelledByDate = await _loadLectureOverrides('home/cancel_lecture.json');
    final madeUpByDate = await _loadLectureOverrides('home/sup_lecture.json');
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final thisWeekMonday = todayDate.subtract(Duration(days: todayDate.weekday - 1));
    final targetDates = List.generate(
      14,
      (index) => thisWeekMonday.add(Duration(days: index)),
    ).where((date) => date.weekday <= DateTime.friday).toList();

    final days = targetDates.map((date) {
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
      for (final override in cancelledByDate[dateKey] ?? const <_LectureOverride>[]) {
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

      for (final override in madeUpByDate[dateKey] ?? const <_LectureOverride>[]) {
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
    return CourseState(days: days);
  }

  Future<Map<String, List<_LectureOverride>>> _loadLectureOverrides(String path) async {
    final data = await _loadJsonList(path);
    final result = <String, List<_LectureOverride>>{};
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final dateRaw = row['date'] as String?;
      final lessonName = row['lessonName'] as String?;
      final periodNumber = row['period'] as int?;
      if (dateRaw == null || lessonName == null || periodNumber == null) continue;
      final period = _toPeriod(periodNumber);
      if (period == null) continue;
      final date = DateTime.tryParse(dateRaw);
      if (date == null) continue;
      final dateKey = _dateKey(date);
      result
          .putIfAbsent(dateKey, () => <_LectureOverride>[])
          .add(_LectureOverride(lessonName: lessonName, period: period));
    }
    return result;
  }

  Future<List<dynamic>> _loadJsonList(String path) async {
    try {
      return await FileHelper.getJSONData(path);
    } on Exception {
      return const <dynamic>[];
    }
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Period? _toPeriod(int number) {
    if (number < 1 || number > Period.values.length) {
      return null;
    }
    return Period.fromNumber(number);
  }
}

final class _LectureOverride {
  _LectureOverride({required this.lessonName, required this.period});

  final String lessonName;
  final Period period;
}
