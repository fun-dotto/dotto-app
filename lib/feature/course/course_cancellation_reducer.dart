import 'package:dotto/domain/course_cancellation.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/feature/course/course_cancellation_state.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_cancellation_reducer.g.dart';

@riverpod
final class CourseCancellationReducer extends _$CourseCancellationReducer {
  @override
  Future<CourseCancellationState> build() async {
    return _createState(isFilteredOnlyTakingCourseCancellation: false);
  }

  Future<void> refresh() async {
    final current = state.value;
    state = await AsyncValue.guard(
      () => _createState(
        isFilteredOnlyTakingCourseCancellation: current?.isFilteredOnlyTakingCourseCancellation ?? false,
      ),
    );
  }

  Future<void> toggleFilter() async {
    final current = state.value;
    state = await AsyncValue.guard(
      () => _createState(
        isFilteredOnlyTakingCourseCancellation: !(current?.isFilteredOnlyTakingCourseCancellation ?? false),
      ),
    );
  }

  Future<CourseCancellationState> _createState({required bool isFilteredOnlyTakingCourseCancellation}) async {
    final lectureCancellationRepository = ref.read(lectureCancellationRepositoryProvider);
    final courseRegistrationRepository = ref.read(courseRegistrationRepositoryProvider);
    final (courseCancellations, courseRegistrations) = await (
      lectureCancellationRepository.getCourseCancellations(),
      courseRegistrationRepository.getCourseRegistrations(Semester.values),
    ).wait;

    final cancellations = isFilteredOnlyTakingCourseCancellation
        ? _filterByTakingCourse(courseCancellations: courseCancellations, courseRegistrations: courseRegistrations)
        : courseCancellations;

    return CourseCancellationState(
      cancellations: cancellations,
      isFilteredOnlyTakingCourseCancellation: isFilteredOnlyTakingCourseCancellation,
    );
  }

  List<CourseCancellation> _filterByTakingCourse({
    required List<CourseCancellation> courseCancellations,
    required List<CourseRegistration> courseRegistrations,
  }) {
    final takingCourseNames = {for (final registration in courseRegistrations) registration.subject.name};
    return courseCancellations.where((cancellation) => takingCourseNames.contains(cancellation.lessonName)).toList();
  }
}
