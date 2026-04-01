import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/cultural_subject_category.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_classification.dart';
import 'package:dotto/domain/subject_requirement_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_filter.freezed.dart';

@freezed
abstract class SubjectFilter with _$SubjectFilter {
  const factory SubjectFilter({
    @Default([]) List<Grade> grades,
    @Default([]) List<AcademicArea> courses,
    @Default([]) List<AcademicClass> classes,
    @Default([]) List<SubjectClassification> classifications,
    @Default([]) List<Semester> semesters,
    @Default([]) List<SubjectRequirementType> requirements,
    @Default([]) List<CulturalSubjectCategory> culturalSubjectCategories,
  }) = _SubjectFilter;

  const SubjectFilter._();

  bool get hasActiveFilters =>
      grades.isNotEmpty ||
      courses.isNotEmpty ||
      classes.isNotEmpty ||
      classifications.isNotEmpty ||
      semesters.isNotEmpty ||
      requirements.isNotEmpty ||
      culturalSubjectCategories.isNotEmpty;
}
