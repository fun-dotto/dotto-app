import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_timetable_calendar_reducer.g.dart';

@riverpod
final class PersonalTimetableCalendarReducer extends _$PersonalTimetableCalendarReducer {
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
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final thisWeekMonday = todayDate.subtract(Duration(days: todayDate.weekday - 1));
      final targetDates = List.generate(14, (index) => thisWeekMonday.add(Duration(days: index)))
          .where((date) => date.weekday <= DateTime.friday)
          .toList();

      return targetDates.map((date) {
        final timetableDayOfWeek = DayOfWeek.fromDateTime(date);
        final items = timetableItems
            .where(
              (item) =>
                  item.slot != null &&
                  registeredSubjectIds.contains(item.subject.id) &&
                  item.slot!.dayOfWeek == timetableDayOfWeek,
            )
            .map(
              (item) => PersonalTimetableItem(
                period: item.slot!.period,
                subject: item.subject,
                lectureStatus: LectureStatus.normal,
                roomName: '',
              ),
            )
            .toList()
          ..sort((a, b) => a.period.number.compareTo(b.period.number));

        return PersonalTimetableDay(date: date, items: items, timetableDayOfWeek: timetableDayOfWeek);
      }).toList();
    });
  }
}
