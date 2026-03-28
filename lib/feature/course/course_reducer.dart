import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/helper/file_helper.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
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
    final personalCalendarRepository = ref.read(personalCalendarRepositoryProvider);

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

    final days = personalCalendarRepository.getPersonalTimetableDays(
      targetDates: targetDates,
      timetableItems: timetableItems,
      registeredSubjectIds: registeredSubjectIds,
      registeredSubjectsByName: registeredSubjectsByName,
      roomAssignmentIndex: roomAssignmentIndex,
      cancelledByDate: cancelledByDate,
      madeUpByDate: madeUpByDate,
    );
    return CourseState(days: days);
  }

  Future<Map<String, List<PersonalCalendarOverride>>> _loadLectureOverrides(String path) async {
    final data = await _loadJsonList(path);
    final result = <String, List<PersonalCalendarOverride>>{};
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
      final dateKey = _formatDateKey(date);
      result
          .putIfAbsent(dateKey, () => <PersonalCalendarOverride>[])
          .add(PersonalCalendarOverride(lessonName: lessonName, period: period));
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

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Period? _toPeriod(int number) {
    if (number < 1 || number > Period.values.length) {
      return null;
    }
    return Period.fromNumber(number);
  }
}
