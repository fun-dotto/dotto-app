import 'package:built_collection/built_collection.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart' as domain;
import 'package:dotto/feature/course/course_cancellation_reducer.dart';
import 'package:dotto/repository/cancelled_class_repository.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/makeup_class_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/room_change_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart' hide CourseRegistration, TimetableItem;

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

final class FakeCancelledClassRepository implements CancelledClassRepository {
  FakeCancelledClassRepository({required this.result});

  final BuiltList<CancelledClass> result;

  @override
  Future<BuiltList<CancelledClass>> getCancelledClasses() async {
    return result;
  }
}

final class FakeMakeupClassRepository implements MakeupClassRepository {
  FakeMakeupClassRepository({required this.result});

  final BuiltList<MakeupClass> result;

  @override
  Future<BuiltList<MakeupClass>> getMakeupClasses() async {
    return result;
  }
}

final class FakeRoomChangeRepository implements RoomChangeRepository {
  FakeRoomChangeRepository({required this.result});

  final BuiltList<RoomChange> result;

  @override
  Future<BuiltList<RoomChange>> getRoomChanges() async {
    return result;
  }
}

CancelledClass _createCancelledClass({required String id, required String subjectId, required String subjectName}) {
  return CancelledClass(
    (b) => b
      ..id = id
      ..subject.replace(
        SubjectSummary(
          (b) => b
            ..id = subjectId
            ..name = subjectName
            ..faculties = ListBuilder<SubjectFaculty>()
            ..year = 2026
            ..semester = DottoFoundationV1CourseSemester.h1
            ..credit = 2,
        ),
      )
      ..date = Date(2026, 4, 1)
      ..period = DottoFoundationV1Period.period1
      ..comment = '',
  );
}

MakeupClass _createMakeupClass({required String id, required String subjectId, required String subjectName}) {
  return MakeupClass(
    (b) => b
      ..id = id
      ..subject.replace(
        SubjectSummary(
          (b) => b
            ..id = subjectId
            ..name = subjectName
            ..faculties = ListBuilder<SubjectFaculty>()
            ..year = 2026
            ..semester = DottoFoundationV1CourseSemester.h1
            ..credit = 2,
        ),
      )
      ..date = Date(2026, 4, 2)
      ..period = DottoFoundationV1Period.period2
      ..comment = '',
  );
}

void main() {
  ProviderContainer createContainer({
    required FakeCancelledClassRepository cancelledClassRepository,
    required FakeMakeupClassRepository makeupClassRepository,
    required FakeRoomChangeRepository roomChangeRepository,
    required FakeCourseRegistrationRepository courseRegistrationRepository,
  }) {
    return ProviderContainer(
      overrides: [
        cancelledClassRepositoryProvider.overrideWithValue(cancelledClassRepository),
        makeupClassRepositoryProvider.overrideWithValue(makeupClassRepository),
        roomChangeRepositoryProvider.overrideWithValue(roomChangeRepository),
        courseRegistrationRepositoryProvider.overrideWithValue(courseRegistrationRepository),
      ],
    );
  }

  test('初期状態では全件が返り、フィルタは無効', () async {
    final container = createContainer(
      cancelledClassRepository: FakeCancelledClassRepository(
        result: BuiltList<CancelledClass>([_createCancelledClass(id: '1', subjectId: 's1', subjectName: 'Math')]),
      ),
      makeupClassRepository: FakeMakeupClassRepository(
        result: BuiltList<MakeupClass>([_createMakeupClass(id: '2', subjectId: 's2', subjectName: 'English')]),
      ),
      roomChangeRepository: FakeRoomChangeRepository(result: BuiltList<RoomChange>()),
      courseRegistrationRepository: FakeCourseRegistrationRepository(result: const []),
    );
    addTearDown(container.dispose);

    final state = await container.read(courseCancellationReducerProvider.future);

    expect(state.isFiltered, isFalse);
    expect(state.cancelledClasses, hasLength(1));
    expect(state.makeupClasses, hasLength(1));
    expect(state.roomChanges, hasLength(0));
  });

  test('フィルタ切替で履修中科目のみ表示される', () async {
    final container = createContainer(
      cancelledClassRepository: FakeCancelledClassRepository(
        result: BuiltList<CancelledClass>([
          _createCancelledClass(id: '1', subjectId: 's1', subjectName: 'Math'),
          _createCancelledClass(id: '2', subjectId: 's2', subjectName: 'English'),
        ]),
      ),
      makeupClassRepository: FakeMakeupClassRepository(
        result: BuiltList<MakeupClass>([_createMakeupClass(id: '3', subjectId: 's1', subjectName: 'Math')]),
      ),
      roomChangeRepository: FakeRoomChangeRepository(result: BuiltList<RoomChange>()),
      courseRegistrationRepository: FakeCourseRegistrationRepository(
        result: [
          CourseRegistration(
            id: 'registration-1',
            subject: domain.SubjectSummary(id: 's1', name: 'Math', faculties: const []),
          ),
        ],
      ),
    );
    addTearDown(container.dispose);

    final notifier = container.read(courseCancellationReducerProvider.notifier);
    await container.read(courseCancellationReducerProvider.future);
    await notifier.toggleFilter();

    final state = container.read(courseCancellationReducerProvider).requireValue;
    expect(state.isFiltered, isTrue);
    expect(state.cancelledClasses, hasLength(1));
    expect(state.cancelledClasses.first.subject.name, 'Math');
    expect(state.makeupClasses, hasLength(1));
  });
}
