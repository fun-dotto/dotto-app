import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/helper/file_helper.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_reducer.g.dart';

@riverpod
final class CourseReducer extends _$CourseReducer {
  static const _roomNameByResourceId = <int, String>{
    1: '講堂',
    2: '大講義室',
    3: '493',
    4: '593',
    5: '594',
    6: '595',
    7: 'R791',
    8: '494C&D',
    9: '495C&D',
    10: '484',
    11: '583',
    12: '584',
    13: '585',
    14: 'R781',
    15: 'R782',
    16: '363',
    17: '364',
    18: '365',
    19: '483',
    50: 'アトリエ',
    51: '体育館',
    90: 'その他',
    99: 'オンライン',
  };

  @override
  Future<List<PersonalTimetableDay>> build() async {
    return const [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final apiClient = ref.read(apiClientProvider);
      final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
      final timetableRepository = TimetableRepositoryImpl(apiClient);

      final (courseRegistrations, timetableItems) = await (
        courseRegistrationRepository.getCourseRegistrations(Semester.values),
        timetableRepository.getTimetableItems(Semester.values),
      ).wait;

      final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
      final registeredSubjectsByName = <String, SubjectSummary>{
        for (final registration in courseRegistrations) registration.subject.name: registration.subject,
      };
      final roomNameBySlotAndTitle = await _loadRoomNameBySlotAndTitle();
      final roomNameByTitle = await _loadRoomNameByTitle();
      final cancelledByDate = await _loadLectureOverrides('home/cancel_lecture.json');
      final madeUpByDate = await _loadLectureOverrides('home/sup_lecture.json');
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final thisWeekMonday = todayDate.subtract(Duration(days: todayDate.weekday - 1));
      final targetDates = List.generate(
        14,
        (index) => thisWeekMonday.add(Duration(days: index)),
      ).where((date) => date.weekday <= DateTime.friday).toList();

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
                  final slotKey = _slotTitleKey(
                    dayOfWeek: timetableDayOfWeek,
                    period: item.slot!.period,
                    title: item.subject.name,
                  );
                  final roomName = roomNameBySlotAndTitle[slotKey] ?? roomNameByTitle[item.subject.name] ?? '';
                  return PersonalTimetableItem(
                    period: item.slot!.period,
                    subject: item.subject,
                    lectureStatus: LectureStatus.normal,
                    roomName: roomName,
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
                roomName: roomNameByTitle[override.lessonName] ?? '',
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
    });
  }

  Future<Map<String, String>> _loadRoomNameBySlotAndTitle() async {
    final data = await _loadJsonList('map/oneweek_schedule.json');
    final map = <String, Set<String>>{};
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final title = row['title'] as String?;
      final start = row['start'] as String?;
      final periodNumber = row['period'] as int?;
      final resourceIdRaw = row['resourceId'] as String?;
      if (title == null || start == null || periodNumber == null || resourceIdRaw == null) continue;
      final period = _toPeriod(periodNumber);
      if (period == null) continue;
      final resourceId = int.tryParse(resourceIdRaw);
      final roomName = resourceId == null ? null : _roomNameByResourceId[resourceId];
      if (roomName == null) continue;
      final date = DateTime.tryParse(start);
      if (date == null) continue;
      final key = _slotTitleKey(dayOfWeek: DayOfWeek.fromDateTime(date), period: period, title: title);
      map.putIfAbsent(key, () => <String>{}).add(roomName);
    }
    return {for (final entry in map.entries) entry.key: entry.value.join(', ')};
  }

  Future<Map<String, String>> _loadRoomNameByTitle() async {
    final data = await _loadJsonList('map/oneweek_schedule.json');
    final map = <String, Set<String>>{};
    for (final row in data) {
      if (row is! Map<String, dynamic>) continue;
      final title = row['title'] as String?;
      final resourceIdRaw = row['resourceId'] as String?;
      if (title == null || resourceIdRaw == null) continue;
      final resourceId = int.tryParse(resourceIdRaw);
      final roomName = resourceId == null ? null : _roomNameByResourceId[resourceId];
      if (roomName == null) continue;
      map.putIfAbsent(title, () => <String>{}).add(roomName);
    }
    return {for (final entry in map.entries) entry.key: entry.value.join(', ')};
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

  String _slotTitleKey({required DayOfWeek dayOfWeek, required Period period, required String title}) {
    return '${dayOfWeek.number}-${period.number}-$title';
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
