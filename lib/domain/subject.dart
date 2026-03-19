import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_eligible_attribute.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_requirement.dart';
import 'package:dotto/domain/syllabus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject.freezed.dart';

@freezed
abstract class Subject with _$Subject {
  const factory Subject({
    required String id,
    required String name,
    required List<SubjectFaculty> faculties,
    required int year,
    required Semester semester,
    required int credit,
    required List<SubjectEligibleAttribute> eligibleAttributes,
    required List<SubjectRequirement> requirements,
    required Syllabus syllabus,
    required String kakomonId,
  }) = _Subject;
}
