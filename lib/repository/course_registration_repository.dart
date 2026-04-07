import 'package:built_collection/built_collection.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/domain/faculty.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart' hide CourseRegistration, SubjectFaculty, SubjectSummary, TimetableItem;

abstract class CourseRegistrationRepository {
  Future<List<CourseRegistration>> getCourseRegistrations(List<Semester> semesters);
  Future<void> registerCourse(String subjectId);
  Future<void> unregisterCourse(String id);
}

final class CourseRegistrationRepositoryImpl implements CourseRegistrationRepository {
  CourseRegistrationRepositoryImpl(this.apiClient);

  final Openapi apiClient;

  @override
  Future<List<CourseRegistration>> getCourseRegistrations(List<Semester> semesters) async {
    try {
      final api = apiClient.getCourseRegistrationsApi();
      final response = await api.courseRegistrationsV1List(
        semesters: BuiltList<DottoFoundationV1CourseSemester>(
          semesters.map(
            (semester) => switch (semester) {
              Semester.h1 => DottoFoundationV1CourseSemester.h1,
              Semester.h2 => DottoFoundationV1CourseSemester.h2,
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
      );
      if (response.statusCode != 200) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get course registrations');
      }
      final data = response.data;
      if (data == null) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get course registrations');
      }
      return data.courseRegistrations
          .map(
            (e) => CourseRegistration(
              id: e.id,
              subject: SubjectSummary(
                id: e.subject.id,
                name: e.subject.name,
                faculties: e.subject.faculties
                    .map(
                      (e) => SubjectFaculty(
                        faculty: Faculty(id: e.faculty.id, name: e.faculty.name, email: e.faculty.email),
                        isPrimary: e.isPrimary,
                      ),
                    )
                    .toList(),
              ),
            ),
          )
          .toList();
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> registerCourse(String subjectId) async {
    try {
      final api = apiClient.getCourseRegistrationsApi();
      final request = CourseRegistrationRequest((b) => b.subjectId = subjectId);
      final response = await api.courseRegistrationsV1Create(courseRegistrationRequest: request);
      if (response.statusCode != 201) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to register course');
      }
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> unregisterCourse(String id) async {
    try {
      final api = apiClient.getCourseRegistrationsApi();
      final response = await api.courseRegistrationsV1Delete(id: id);
      if (response.statusCode != 204) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to unregister course');
      }
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      debugPrint(e.toString());
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
  }
}
