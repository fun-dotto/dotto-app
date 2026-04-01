import 'package:dotto/domain/course_cancellation.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/lecture_cancellation_repository.dart';
import 'package:dotto/repository/oneweek_schedule_repository.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeCourseRegistrationRepository implements CourseRegistrationRepository {
  FakeCourseRegistrationRepository({required this.result});

  final List<CourseRegistration> result;
  int getCourseRegistrationsCallCount = 0;

  @override
  Future<List<CourseRegistration>> getCourseRegistrations(List<Semester> semesters) async {
    getCourseRegistrationsCallCount += 1;
    return result;
  }

  @override
  Future<void> registerCourse(String subjectId) {
    throw UnimplementedError();
  }

  @override
  Future<void> unregisterCourse(String id) {
    throw UnimplementedError();
  }
}

final class FakeLectureCancellationRepository implements LectureCancellationRepository {
  FakeLectureCancellationRepository({required this.result});

  final LectureCancellationData result;
  int getLectureCancellationDataCallCount = 0;

  @override
  Future<LectureCancellationData> getLectureCancellationData() async {
    getLectureCancellationDataCallCount += 1;
    return result;
  }

  @override
  Future<List<CourseCancellation>> getCourseCancellations() {
    throw UnimplementedError();
  }
}

final class FakeOneWeekScheduleRepository implements OneWeekScheduleRepository {
  FakeOneWeekScheduleRepository({required this.schedules});

  final List<OneWeekScheduleEntry> schedules;
  int getSchedulesCallCount = 0;

  @override
  Future<List<OneWeekScheduleEntry>> getSchedules() async {
    getSchedulesCallCount += 1;
    return schedules;
  }
}

final class FakePersonalCalendarRepository implements PersonalCalendarRepository {
  FakePersonalCalendarRepository({required this.result});

  final List<PersonalTimetableDay> result;
  List<DateTime>? capturedTargetDates;

  @override
  List<PersonalTimetableDay> getPersonalTimetableDays({
    required List<DateTime> targetDates,
    required List<OneWeekScheduleEntry> schedules,
    required Map<String, SubjectSummary> registeredSubjectsById,
    required Map<String, SubjectSummary> registeredSubjectsByName,
    required Map<String, List<LectureOverride>> cancelledByDate,
    required Map<String, List<LectureOverride>> madeUpByDate,
  }) {
    capturedTargetDates = targetDates;
    return result;
  }
}

void main() {
  ProviderContainer createContainer({
    required FakeCourseRegistrationRepository courseRegistrationRepository,
    required FakeLectureCancellationRepository lectureCancellationRepository,
    required FakeOneWeekScheduleRepository oneWeekScheduleRepository,
    required FakePersonalCalendarRepository personalCalendarRepository,
    bool isAuthenticated = true,
  }) {
    return ProviderContainer(
      overrides: [
        courseRegistrationRepositoryProvider.overrideWithValue(courseRegistrationRepository),
        lectureCancellationRepositoryProvider.overrideWithValue(lectureCancellationRepository),
        oneWeekScheduleRepositoryProvider.overrideWithValue(oneWeekScheduleRepository),
        personalCalendarRepositoryProvider.overrideWithValue(personalCalendarRepository),
        courseCanFetchProtectedDataProvider.overrideWithValue(() async => isAuthenticated),
        clockProvider.overrideWithValue(() => DateTime(2026, 4, 8, 12)),
      ],
    );
  }

  test('build は平日2週分を計算して days に反映する', () async {
    final subject = SubjectSummary(id: 'subject-1', name: 'Math', faculties: const []);
    final courseRegistrationRepository = FakeCourseRegistrationRepository(
      result: [CourseRegistration(id: 'registration-1', subject: subject)],
    );
    final lectureCancellationRepository = FakeLectureCancellationRepository(
      result: LectureCancellationData(cancelledByDate: {}, madeUpByDate: {}),
    );
    final oneWeekScheduleRepository = FakeOneWeekScheduleRepository(schedules: const []);
    final expectedDays = [
      PersonalTimetableDay(date: DateTime(2026, 4, 6), items: const [], timetableDayOfWeek: DayOfWeek.monday),
    ];
    final personalCalendarRepository = FakePersonalCalendarRepository(result: expectedDays);

    final container = createContainer(
      courseRegistrationRepository: courseRegistrationRepository,
      lectureCancellationRepository: lectureCancellationRepository,
      oneWeekScheduleRepository: oneWeekScheduleRepository,
      personalCalendarRepository: personalCalendarRepository,
    );
    addTearDown(container.dispose);

    final state = await container.read(courseReducerProvider.future);

    expect(state.days, expectedDays);
    expect(courseRegistrationRepository.getCourseRegistrationsCallCount, 1);
    expect(lectureCancellationRepository.getLectureCancellationDataCallCount, 1);
    expect(oneWeekScheduleRepository.getSchedulesCallCount, 1);

    final targetDates = personalCalendarRepository.capturedTargetDates;
    expect(targetDates, isNotNull);
    expect(targetDates, hasLength(10));
    expect(targetDates!.first, DateTime(2026, 4, 6));
    expect(targetDates.last, DateTime(2026, 4, 17));
    expect(targetDates.every((date) => date.weekday <= DateTime.friday), isTrue);
  });

  test('未認証時は PersonalTimetableDay を取得しない', () async {
    final subject = SubjectSummary(id: 'subject-1', name: 'Math', faculties: const []);
    final courseRegistrationRepository = FakeCourseRegistrationRepository(
      result: [CourseRegistration(id: 'registration-1', subject: subject)],
    );
    final lectureCancellationRepository = FakeLectureCancellationRepository(
      result: LectureCancellationData(cancelledByDate: {}, madeUpByDate: {}),
    );
    final oneWeekScheduleRepository = FakeOneWeekScheduleRepository(schedules: const []);
    final personalCalendarRepository = FakePersonalCalendarRepository(result: const []);

    final container = createContainer(
      courseRegistrationRepository: courseRegistrationRepository,
      lectureCancellationRepository: lectureCancellationRepository,
      oneWeekScheduleRepository: oneWeekScheduleRepository,
      personalCalendarRepository: personalCalendarRepository,
      isAuthenticated: false,
    );
    addTearDown(container.dispose);

    final state = await container.read(courseReducerProvider.future);

    expect(state.days, isEmpty);
    expect(courseRegistrationRepository.getCourseRegistrationsCallCount, 0);
    expect(lectureCancellationRepository.getLectureCancellationDataCallCount, 0);
    expect(oneWeekScheduleRepository.getSchedulesCallCount, 0);
    expect(personalCalendarRepository.capturedTargetDates, isNull);
  });
}
