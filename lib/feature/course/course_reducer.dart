import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_reducer.g.dart';

typedef Clock = DateTime Function();

final clockProvider = Provider<Clock>((_) => DateTime.now);

@riverpod
final class CourseReducer extends _$CourseReducer {
  @override
  Future<CourseState> build() async {
    return _createCourseState();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_createCourseState);
  }

  Future<CourseState> _createCourseState() async {
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    final lectureCancellationRepository = ref.read(lectureCancellationRepositoryProvider);
    final timetableRepository = ref.read(timetableRepositoryProvider);
    final roomRepository = ref.read(roomRepositoryProvider);
    final personalCalendarRepository = ref.read(personalCalendarRepositoryProvider);

    final (courseRegistrations, lectureCancellationData, timetableItems, roomAssignmentIndex) = await (
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
      lectureCancellationRepository.getLectureCancellationData(),
      timetableRepository.getTimetableItems(Semester.values),
      roomRepository.getRoomAssignmentIndex(),
    ).wait;

    final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
    final registeredSubjectsByName = <String, SubjectSummary>{
      for (final registration in courseRegistrations) registration.subject.name: registration.subject,
    };
    final now = ref.read(clockProvider);
    final today = now();
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
      cancelledByDate: lectureCancellationData.cancelledByDate,
      madeUpByDate: lectureCancellationData.madeUpByDate,
    );
    return CourseState(days: days);
  }
}
