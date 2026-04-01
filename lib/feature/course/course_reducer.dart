import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_reducer.g.dart';

typedef Clock = DateTime Function();
typedef CourseCanFetchProtectedData = Future<bool> Function();

final clockProvider = Provider<Clock>((_) => DateTime.now);
final courseCanFetchProtectedDataProvider = Provider<CourseCanFetchProtectedData>((_) {
  return () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      final idToken = await user.getIdToken();
      return idToken != null && idToken.isNotEmpty;
    } on Exception {
      return false;
    }
  };
});

@riverpod
final class CourseReducer extends _$CourseReducer {
  @override
  Future<CourseState> build() async {
    return _createCourseState();
  }

  Future<void> refresh() async {
    final nextState = await AsyncValue.guard(_createCourseState);
    if (!ref.mounted) {
      return;
    }
    state = nextState;
  }

  Future<CourseState> _createCourseState() async {
    final canFetchProtectedData = await ref.read(courseCanFetchProtectedDataProvider)();
    if (!ref.mounted || !canFetchProtectedData) {
      return const CourseState();
    }

    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    final lectureCancellationRepository = ref.read(lectureCancellationRepositoryProvider);
    final roomRepository = ref.read(roomRepositoryProvider);
    final personalCalendarRepository = ref.read(personalCalendarRepositoryProvider);

    final (courseRegistrations, lectureCancellationData, rooms) = await (
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
      lectureCancellationRepository.getLectureCancellationData(),
      roomRepository.getRooms(),
    ).wait;
    if (!ref.mounted) {
      return const CourseState();
    }

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
      rooms: rooms,
      registeredSubjectsByName: registeredSubjectsByName,
      cancelledByDate: lectureCancellationData.cancelledByDate,
      madeUpByDate: lectureCancellationData.madeUpByDate,
    );
    return CourseState(days: days);
  }
}
