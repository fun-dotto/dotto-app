import 'package:dotto/domain/course_cancellation.dart';
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
    if (current == null) {
      await refresh();
      return;
    }

    final nextIsFilteredOnlyTakingCourseCancellation = !current.isFilteredOnlyTakingCourseCancellation;
    final nextCancellations = nextIsFilteredOnlyTakingCourseCancellation
        ? _filterByTakingCourse(
            courseCancellations: current.allCancellations,
            takingCourseNames: current.takingCourseNames,
          )
        : current.allCancellations;

    state = AsyncData(
      current.copyWith(
        cancellations: nextCancellations,
        isFilteredOnlyTakingCourseCancellation: nextIsFilteredOnlyTakingCourseCancellation,
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

    final takingCourseNames = {for (final registration in courseRegistrations) registration.subject.name};
    final cancellations = isFilteredOnlyTakingCourseCancellation
        ? _filterByTakingCourse(courseCancellations: courseCancellations, takingCourseNames: takingCourseNames)
        : courseCancellations;

    return CourseCancellationState(
      cancellations: cancellations,
      allCancellations: courseCancellations,
      takingCourseNames: takingCourseNames,
      isFilteredOnlyTakingCourseCancellation: isFilteredOnlyTakingCourseCancellation,
    );
  }

  List<CourseCancellation> _filterByTakingCourse({
    required List<CourseCancellation> courseCancellations,
    required Set<String> takingCourseNames,
  }) {
    return courseCancellations.where((cancellation) => takingCourseNames.contains(cancellation.lessonName)).toList();
  }
}
