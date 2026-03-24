import 'package:freezed_annotation/freezed_annotation.dart';

part 'syllabus.freezed.dart';

@freezed
abstract class Syllabus with _$Syllabus {
  const factory Syllabus({
    required String id,
    required String name,
    required String enName,
    required String grades,
    required int credit,
    required String facultyNames,
    required String practicalHomeFacultyCategory,
    required String multiplePersonTeachingForm,
    required String teachingForm,
    required String summary,
    required String learningOutcomes,
    required String assignments,
    required String evaluationMethod,
    required String textbooks,
    required String referenceBooks,
    required String prerequisites,
    required String preLearning,
    required String postLearning,
    required String notes,
    required String keywords,
    required String targetCourses,
    required String targetAreas,
    required String classifications,
    required String teachingLanguage,
    required String contentsAndSchedule,
    required String teachingAndExamForm,
    required String dsopSubject,
  }) = _Syllabus;
}
