import 'package:dotto/domain/subject_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_registration.freezed.dart';

@freezed
abstract class CourseRegistration with _$CourseRegistration {
  const factory CourseRegistration({required String id, required SubjectSummary subject}) = _CourseRegistration;
}
