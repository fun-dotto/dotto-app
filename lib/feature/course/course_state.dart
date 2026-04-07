import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_state.freezed.dart';

@freezed
abstract class CourseState with _$CourseState {
  const factory CourseState({
    @Default(<PersonalTimetableDay>[]) List<PersonalTimetableDay> days,
  }) = _CourseState;
}
