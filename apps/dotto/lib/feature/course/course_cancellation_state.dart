import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:openapi/openapi.dart';

part 'course_cancellation_state.freezed.dart';

@freezed
abstract class CourseCancellationState with _$CourseCancellationState {
  const factory CourseCancellationState({
    @Default(<CancelledClass>[]) List<CancelledClass> cancelledClasses,
    @Default(<MakeupClass>[]) List<MakeupClass> makeupClasses,
    @Default(<RoomChange>[]) List<RoomChange> roomChanges,
    @Default(false) bool isFiltered,
  }) = _CourseCancellationState;
}
