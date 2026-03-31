import 'package:dotto/domain/course_cancellation.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/lecture_override.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_cancellation_reducer.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/lecture_cancellation_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakeCourseRegistrationRepository implements CourseRegistrationRepository {
  FakeCourseRegistrationRepository({required this.result});

  final List<CourseRegistration> result;

  @override
  Future<List<CourseRegistration>> getCourseRegistrations(List<Semester> semesters) async {
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

  final List<CourseCancellation> result;

  @override
  Future<LectureCancellationData> getLectureCancellationData() {
    throw UnimplementedError();
  }

  @override
  Future<List<CourseCancellation>> getCourseCancellations() async {
    return result;
  }
}

void main() {
  CourseCancellation createCancellation({
    required String lessonName,
    required CourseCancellationType type,
    required int period,
    required DateTime date,
  }) {
    return CourseCancellation(
      date: date,
      period: Period.fromNumber(period),
      lessonName: lessonName,
      comment: '',
      type: type,
    );
  }

  ProviderContainer createContainer({
    required FakeLectureCancellationRepository lectureCancellationRepository,
    required FakeCourseRegistrationRepository courseRegistrationRepository,
  }) {
    return ProviderContainer(
      overrides: [
        lectureCancellationRepositoryProvider.overrideWithValue(lectureCancellationRepository),
        courseRegistrationRepositoryProvider.overrideWithValue(courseRegistrationRepository),
      ],
    );
  }

  test('初期状態では全件が返り、フィルタは無効', () async {
    final lectureCancellationRepository = FakeLectureCancellationRepository(
      result: [
        createCancellation(
          lessonName: 'Math',
          type: CourseCancellationType.cancellation,
          period: 1,
          date: DateTime(2026, 4, 1),
        ),
        createCancellation(
          lessonName: 'English',
          type: CourseCancellationType.makeUp,
          period: 2,
          date: DateTime(2026, 4, 2),
        ),
      ],
    );
    final courseRegistrationRepository = FakeCourseRegistrationRepository(result: const []);
    final container = createContainer(
      lectureCancellationRepository: lectureCancellationRepository,
      courseRegistrationRepository: courseRegistrationRepository,
    );
    addTearDown(container.dispose);

    final state = await container.read(courseCancellationReducerProvider.future);

    expect(state.isFilteredOnlyTakingCourseCancellation, isFalse);
    expect(state.cancellations, hasLength(2));
  });

  test('フィルタ切替で履修中科目のみ表示される', () async {
    final lectureCancellationRepository = FakeLectureCancellationRepository(
      result: [
        createCancellation(
          lessonName: 'Math',
          type: CourseCancellationType.cancellation,
          period: 1,
          date: DateTime(2026, 4, 1),
        ),
        createCancellation(
          lessonName: 'English',
          type: CourseCancellationType.makeUp,
          period: 2,
          date: DateTime(2026, 4, 2),
        ),
      ],
    );
    final courseRegistrationRepository = FakeCourseRegistrationRepository(
      result: [
        CourseRegistration(
          id: 'registration-1',
          subject: SubjectSummary(id: 'subject-1', name: 'Math', faculties: const []),
        ),
      ],
    );
    final container = createContainer(
      lectureCancellationRepository: lectureCancellationRepository,
      courseRegistrationRepository: courseRegistrationRepository,
    );
    addTearDown(container.dispose);

    final notifier = container.read(courseCancellationReducerProvider.notifier);
    await container.read(courseCancellationReducerProvider.future);
    await notifier.toggleFilter();

    final state = container.read(courseCancellationReducerProvider).requireValue;
    expect(state.isFilteredOnlyTakingCourseCancellation, isTrue);
    expect(state.cancellations, hasLength(1));
    expect(state.cancellations.first.lessonName, 'Math');
  });
}
