import 'dart:async';

import 'package:dotto/controller/user_controller.dart';
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
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeCourseRegistrationRepository
    implements CourseRegistrationRepository {
  FakeCourseRegistrationRepository({required this.result});

  final List<CourseRegistration> result;
  int getCourseRegistrationsCallCount = 0;

  @override
  Future<List<CourseRegistration>> getCourseRegistrations(
    List<Semester> semesters,
  ) async {
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
  FakeSubjectRepository({
    required this.resultsByQuery,
    this.futuresByQuery = const {},
  });

  final Map<String, List<SubjectSummary>> resultsByQuery;
  final Map<String, Future<List<SubjectSummary>>> futuresByQuery;
  int getSubjectsCallCount = 0;

  @override
  Future<List<SubjectSummary>> getSubjects(
    String query,
    SubjectFilter filter,
  ) async {
    getSubjectsCallCount += 1;
    final future = futuresByQuery[query];
    if (future != null) {
      return future;
    }
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
  Future<List<TimetableItem>> getTimetableItems(
    List<Semester> semesters,
  ) async {
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
        isAuthenticatedProvider.overrideWith((ref) => true),
        courseRegistrationRepositoryProvider.overrideWithValue(
          courseRegistrationRepository,
        ),
        subjectRepositoryProvider.overrideWithValue(subjectRepository),
        timetableRepositoryProvider.overrideWithValue(timetableRepository),
      ],
    );
  }

  test('search で slots と isAddedToTimetable がマージされる', () async {
    final withSlot = SubjectSummary(
      id: 'subject-1',
      name: 'Math',
      faculties: const [],
    );
    final withoutSlot = SubjectSummary(
      id: 'subject-2',
      name: 'English',
      faculties: const [],
    );

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
          subject: withSlot,
          slot: const TimetableSlot(
            dayOfWeek: DayOfWeek.monday,
            period: Period.first,
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

    await container
        .read(searchSubjectReducerProvider.notifier)
        .search(query: 'math', filter: filter);

    final value = container.read(searchSubjectReducerProvider).requireValue;
    final subjects = value.subjects;

    expect(subjects, hasLength(2));
    expect(value.filter, filter);
    expect(subjects[0].id, 'subject-1');
    expect(subjects[0].slots, [
      const TimetableSlot(dayOfWeek: DayOfWeek.monday, period: Period.first),
    ]);
    expect(subjects[0].isAddedToTimetable, isTrue);
    expect(subjects[1].id, 'subject-2');
    expect(subjects[1].slots, isNull);
    expect(subjects[1].isAddedToTimetable, isFalse);
  });

  test('timetableItems は初回検索のみ取得される', () async {
    final subject = SubjectSummary(
      id: 'subject-1',
      name: 'Math',
      faculties: const [],
    );

    final courseRegistrationRepository = FakeCourseRegistrationRepository(
      result: const [],
    );
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

  test('search 中も直前の filter を保持する', () async {
    final delayedSubjects = Completer<List<SubjectSummary>>();
    final activeFilter = SubjectFilter(grades: const []);
    final subjectRepository = FakeSubjectRepository(
      resultsByQuery: const {},
      futuresByQuery: {'math': delayedSubjects.future},
    );
    final container = createContainer(
      courseRegistrationRepository: FakeCourseRegistrationRepository(
        result: const [],
      ),
      subjectRepository: subjectRepository,
      timetableRepository: FakeTimetableRepository(result: const []),
    );
    addTearDown(container.dispose);

    final notifier = container.read(searchSubjectReducerProvider.notifier);
    notifier.updateFilter(activeFilter);
    final searchFuture = notifier.search(query: 'math', filter: activeFilter);

    final loadingState = container.read(searchSubjectReducerProvider);
    expect(loadingState.isLoading, isTrue);
    expect(loadingState.hasValue, isTrue);
    expect(loadingState.requireValue.filter, activeFilter);

    delayedSubjects.complete(const []);
    await searchFuture;
  });

  test('古い検索結果では filter と subjects を巻き戻さない', () async {
    final firstSubjects = Completer<List<SubjectSummary>>();
    final secondSubjects = Completer<List<SubjectSummary>>();
    final firstFilter = SubjectFilter(grades: const []);
    final secondFilter = SubjectFilter(semesters: const [Semester.h1]);
    final oldSubject = SubjectSummary(
      id: 'subject-old',
      name: 'Old',
      faculties: const [],
    );
    final newSubject = SubjectSummary(
      id: 'subject-new',
      name: 'New',
      faculties: const [],
    );

    final subjectRepository = FakeSubjectRepository(
      resultsByQuery: const {},
      futuresByQuery: {
        'first': firstSubjects.future,
        'second': secondSubjects.future,
      },
    );
    final container = createContainer(
      courseRegistrationRepository: FakeCourseRegistrationRepository(
        result: const [],
      ),
      subjectRepository: subjectRepository,
      timetableRepository: FakeTimetableRepository(result: const []),
    );
    addTearDown(container.dispose);

    final notifier = container.read(searchSubjectReducerProvider.notifier);
    final firstSearch = notifier.search(query: 'first', filter: firstFilter);
    final secondSearch = notifier.search(query: 'second', filter: secondFilter);

    secondSubjects.complete([newSubject]);
    await secondSearch;

    firstSubjects.complete([oldSubject]);
    await firstSearch;

    final value = container.read(searchSubjectReducerProvider).requireValue;
    expect(value.filter, secondFilter);
    expect(value.subjects, [newSubject.copyWith(isAddedToTimetable: false)]);
  });
}
