import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/grade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_eligible_attribute.freezed.dart';

@freezed
abstract class SubjectEligibleAttribute with _$SubjectEligibleAttribute {
  const factory SubjectEligibleAttribute({
    required Grade grade,
    required AcademicClass? class_,
  }) = _SubjectEligibleAttribute;
}
