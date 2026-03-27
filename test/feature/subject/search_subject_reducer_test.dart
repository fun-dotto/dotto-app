import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject.dart';
import 'package:dotto/domain/subject_feedback.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:dotto/feature/subject/search_subject_reducer.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
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

final class FakeSubjectRepository implements SubjectRepository {
  FakeSubjectRepository({required this.resultsByQuery});

  final Map<String, List<SubjectSummary>> resultsByQuery;
  int getSubjectsCallCount = 0;

  @override
  Future<List<SubjectSummary>> getSubjects(String query, SubjectFilter filter) async {
    getSubjectsCallCount += 1;
    return resultsByQuery[query] ?? const [];
  }

  @override
  Future<void> createFeedback({
    required String userId,
    required String lessonId,
    required int score,
    required String comment,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<SubjectFeedback>> getFeedbacks(String lessonId) {
    throw UnimplementedError();
  }

  @override
  Future<Subject> getSubject(String id) {
    throw UnimplementedError();
  }
}

final class FakeTimetableRepository implements TimetableRepository {
  FakeTimetableRepository({required this.result});

  final List<TimetableItem> result;
  int getTimetableItemsCallCount = 0;

  @override
  Future<List<TimetableItem>> getTimetableItems(List<Semester> semesters) async {
    getTimetableItemsCallCount += 1;
    return result;
  }
}

void main() {
  final filter = SubjectFilter();

  ProviderContainer createContainer({
    required FakeCourseRegistrationRepository courseRegistrationRepository,
    required FakeSubjectRepository subjectRepository,
    required FakeTimetableRepository timetableRepository,
  }) {
    return ProviderContainer(
      overrides: [
        courseRegistrationRepositoryProvider.overrideWithValue(courseRegistrationRepository),
        subjectRepositoryProvider.overrideWithValue(subjectRepository),
        timetableRepositoryProvider.overrideWithValue(timetableRepository),
      ],
    );
  }

  test('search で slot と isAddedToTimetable がマージされる', () async {
    final withSlot = SubjectSummary(id: 'subject-1', name: 'Math', faculties: const []);
    final withoutSlot = SubjectSummary(id: 'subject-2', name: 'English', faculties: const []);

    final courseRegistrationRepository = FakeCourseRegistrationRepository(
      result: [CourseRegistration(id: 'reg-1', subject: withSlot)],
    );
    final subjectRepository = FakeSubjectRepository(
      resultsByQuery: {
        'math': [withSlot, withoutSlot],
      },
    );
    final timetableRepository = FakeTimetableRepository(
      result: [
        TimetableItem(
          id: 'item-1',
          subject: withSlot.copyWith(
            slot: const TimetableSlot(dayOfWeek: DayOfWeek.monday, period: Period.first),
          ),
        ),
      ],
    );

    final container = createContainer(
      courseRegistrationRepository: courseRegistrationRepository,
      subjectRepository: subjectRepository,
      timetableRepository: timetableRepository,
    );
    addTearDown(container.dispose);

    await container.read(searchSubjectReducerProvider.notifier).search(query: 'math', filter: filter);

    final value = container.read(searchSubjectReducerProvider).requireValue;

    expect(value, hasLength(2));
    expect(value[0].id, 'subject-1');
    expect(value[0].slot, const TimetableSlot(dayOfWeek: DayOfWeek.monday, period: Period.first));
    expect(value[0].isAddedToTimetable, isTrue);
    expect(value[1].id, 'subject-2');
    expect(value[1].slot, isNull);
    expect(value[1].isAddedToTimetable, isFalse);
  });

  test('timetableItems は初回検索のみ取得される', () async {
    final subject = SubjectSummary(id: 'subject-1', name: 'Math', faculties: const []);

    final courseRegistrationRepository = FakeCourseRegistrationRepository(result: const []);
    final subjectRepository = FakeSubjectRepository(
      resultsByQuery: {
        'first': [subject],
        'second': [subject],
      },
    );
    final timetableRepository = FakeTimetableRepository(result: const []);

    final container = createContainer(
      courseRegistrationRepository: courseRegistrationRepository,
      subjectRepository: subjectRepository,
      timetableRepository: timetableRepository,
    );
    addTearDown(container.dispose);

    final notifier = container.read(searchSubjectReducerProvider.notifier);
    await notifier.search(query: 'first', filter: filter);
    await notifier.search(query: 'second', filter: filter);

    expect(timetableRepository.getTimetableItemsCallCount, 1);
    expect(courseRegistrationRepository.getCourseRegistrationsCallCount, 2);
    expect(subjectRepository.getSubjectsCallCount, 2);
  });
}
