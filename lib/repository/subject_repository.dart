import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/cultural_subject_category.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/faculty.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_classification.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_requirement.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/search_subject/domain/subject_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart' hide SubjectFaculty, SubjectSummary;

extension IterableToBuiltListOrNullExtension<E> on Iterable<E> {
  BuiltList<T>? mapToBuiltListOrNull<T>(T Function(E) convert) {
    if (isEmpty) {
      return null;
    }
    return BuiltList<T>(map(convert));
  }
}

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) => SubjectRepositoryImpl(ref));

abstract class SubjectRepository {
  Future<List<SubjectSummary>> getSubjects(String query, SubjectFilter filter);
}

final class SubjectRepositoryImpl implements SubjectRepository {
  SubjectRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<List<SubjectSummary>> getSubjects(String query, SubjectFilter filter) async {
    try {
      final api = ref.read(apiClientProvider).getSubjectsApi();
      final response = await api.subjectsV1List(
        q: query,
        grade: filter.grades.mapToBuiltListOrNull(
          (e) => switch (e) {
            Grade.b1 => DottoFoundationV1Grade.b1,
            Grade.b2 => DottoFoundationV1Grade.b2,
            Grade.b3 => DottoFoundationV1Grade.b3,
            Grade.b4 => DottoFoundationV1Grade.b4,
            Grade.m1 => DottoFoundationV1Grade.m1,
            Grade.m2 => DottoFoundationV1Grade.m2,
            Grade.d1 => DottoFoundationV1Grade.d1,
            Grade.d2 => DottoFoundationV1Grade.d2,
            Grade.d3 => DottoFoundationV1Grade.d3,
          },
        ),
        courses: filter.courses.mapToBuiltListOrNull(
          (e) => switch (e) {
            AcademicArea.informationSystemCourse => DottoFoundationV1Course.informationSystem,
            AcademicArea.informationDesignCourse => DottoFoundationV1Course.informationDesign,
            AcademicArea.complexCourse => DottoFoundationV1Course.complexSystem,
            AcademicArea.intelligenceSystemCourse => DottoFoundationV1Course.intelligentSystem,
            AcademicArea.advancedICTCourse => DottoFoundationV1Course.advancedICT,
            AcademicArea.informationArchitectureArea => DottoFoundationV1Course.informationSystem,
            AcademicArea.mediaDesignArea => DottoFoundationV1Course.informationDesign,
            AcademicArea.complexInformationScienceArea => DottoFoundationV1Course.complexSystem,
            AcademicArea.intelligenceInformationScienceArea => DottoFoundationV1Course.intelligentSystem,
            AcademicArea.advancedICTArea => DottoFoundationV1Course.advancedICT,
          },
        ),
        class_: filter.classes.isEmpty
            ? null
            : BuiltList<DottoFoundationV1Class>(
                filter.classes.map(
                  (e) => switch (e) {
                    AcademicClass.a => DottoFoundationV1Class.A,
                    AcademicClass.b => DottoFoundationV1Class.B,
                    AcademicClass.c => DottoFoundationV1Class.C,
                    AcademicClass.d => DottoFoundationV1Class.D,
                    AcademicClass.e => DottoFoundationV1Class.E,
                    AcademicClass.f => DottoFoundationV1Class.F,
                    AcademicClass.g => DottoFoundationV1Class.G,
                    AcademicClass.h => DottoFoundationV1Class.H,
                    AcademicClass.i => DottoFoundationV1Class.I,
                    AcademicClass.j => DottoFoundationV1Class.J,
                    AcademicClass.k => DottoFoundationV1Class.K,
                    AcademicClass.l => DottoFoundationV1Class.L,
                  },
                ),
              ),
        classification: filter.classifications.isEmpty
            ? null
            : BuiltList<DottoFoundationV1SubjectClassification>(
                filter.classifications.map(
                  (e) => switch (e) {
                    SubjectClassification.specialized => DottoFoundationV1SubjectClassification.specialized,
                    SubjectClassification.cultural => DottoFoundationV1SubjectClassification.cultural,
                    SubjectClassification.researchInstruction =>
                      DottoFoundationV1SubjectClassification.researchInstruction,
                  },
                ),
              ),
        semester: filter.semesters.isEmpty
            ? null
            : BuiltList<DottoFoundationV1CourseSemester>(
                filter.semesters.map(
                  (e) => switch (e) {
                    Semester.spring => DottoFoundationV1CourseSemester.h1,
                    Semester.fall => DottoFoundationV1CourseSemester.h2,
                    Semester.allYear => DottoFoundationV1CourseSemester.allYear,
                    Semester.q1 => DottoFoundationV1CourseSemester.q1,
                    Semester.q2 => DottoFoundationV1CourseSemester.q2,
                    Semester.q3 => DottoFoundationV1CourseSemester.q3,
                    Semester.q4 => DottoFoundationV1CourseSemester.q4,
                    Semester.summerIntensive => DottoFoundationV1CourseSemester.summerIntensive,
                    Semester.winterIntensive => DottoFoundationV1CourseSemester.winterIntensive,
                  },
                ),
              ),
        requirementType: filter.requirements.isEmpty
            ? null
            : BuiltList<DottoFoundationV1SubjectRequirementType>(
                filter.requirements.map(
                  (e) => switch (e) {
                    SubjectRequirement.required => DottoFoundationV1SubjectRequirementType.required_,
                    SubjectRequirement.optional => DottoFoundationV1SubjectRequirementType.optional,
                    SubjectRequirement.optionalRequired => DottoFoundationV1SubjectRequirementType.optionalRequired,
                  },
                ),
              ),
        culturalSubjectCategory: filter.culturalSubjectCategories.isEmpty
            ? null
            : BuiltList<DottoFoundationV1CulturalSubjectCategory>(
                filter.culturalSubjectCategories.map(
                  (e) => switch (e) {
                    CulturalSubjectCategory.society => DottoFoundationV1CulturalSubjectCategory.society,
                    CulturalSubjectCategory.human => DottoFoundationV1CulturalSubjectCategory.human,
                    CulturalSubjectCategory.science => DottoFoundationV1CulturalSubjectCategory.science,
                    CulturalSubjectCategory.health => DottoFoundationV1CulturalSubjectCategory.health,
                    CulturalSubjectCategory.communication => DottoFoundationV1CulturalSubjectCategory.communication,
                  },
                ),
              ),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to get subjects');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to get subjects');
      }
      return data.subjects
          .map(
            (e) => SubjectSummary(
              id: e.id,
              name: e.name,
              faculties: e.faculties
                  .map(
                    (e) => SubjectFaculty(
                      faculty: Faculty(id: e.faculty.id, name: e.faculty.name, email: e.faculty.email),
                      isPrimary: e.isPrimary,
                    ),
                  )
                  .toList(),
              dayOfWeek: switch (e.dayOfWeek) {
                DottoFoundationV1DayOfWeek.monday => DayOfWeek.monday,
                DottoFoundationV1DayOfWeek.tuesday => DayOfWeek.tuesday,
                DottoFoundationV1DayOfWeek.wednesday => DayOfWeek.wednesday,
                DottoFoundationV1DayOfWeek.thursday => DayOfWeek.thursday,
                DottoFoundationV1DayOfWeek.friday => DayOfWeek.friday,
                DottoFoundationV1DayOfWeek.saturday => DayOfWeek.saturday,
                DottoFoundationV1DayOfWeek.sunday => DayOfWeek.sunday,
                _ => throw Exception('Invalid day of week'),
              },
              period: switch (e.period) {
                DottoFoundationV1Period.period1 => Period.first,
                DottoFoundationV1Period.period2 => Period.second,
                DottoFoundationV1Period.period3 => Period.third,
                DottoFoundationV1Period.period4 => Period.fourth,
                DottoFoundationV1Period.period5 => Period.fifth,
                DottoFoundationV1Period.period6 => Period.sixth,
                _ => throw Exception('Invalid period'),
              },
              isAddedToTimetable: e.isAddedToTimetable,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
