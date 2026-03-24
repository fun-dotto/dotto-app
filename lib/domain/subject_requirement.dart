import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/subject_requirement_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_requirement.freezed.dart';

@freezed
abstract class SubjectRequirement with _$SubjectRequirement {
  const factory SubjectRequirement({required AcademicArea course, required SubjectRequirementType requirementType}) =
      _SubjectRequirement;
}
