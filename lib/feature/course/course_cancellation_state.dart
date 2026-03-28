import 'package:dotto/domain/course_cancellation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_cancellation_state.freezed.dart';

@freezed
abstract class CourseCancellationState with _$CourseCancellationState {
  const factory CourseCancellationState({
    @Default(<CourseCancellation>[]) List<CourseCancellation> cancellations,
    @Default(<CourseCancellation>[]) List<CourseCancellation> allCancellations,
    @Default(<String>{}) Set<String> takingCourseNames,
    @Default(false) bool isFilteredOnlyTakingCourseCancellation,
  }) = _CourseCancellationState;
}
