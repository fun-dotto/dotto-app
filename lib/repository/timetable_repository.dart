import 'package:built_collection/built_collection.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/domain/faculty.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_slot.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart' hide SubjectFaculty, SubjectSummary, TimetableItem;

abstract class TimetableRepository {
  Future<List<TimetableItem>> getTimetableItems(List<Semester> semesters);
}

final class TimetableRepositoryImpl implements TimetableRepository {
  TimetableRepositoryImpl(this.apiClient);

  final Openapi apiClient;

  @override
  Future<List<TimetableItem>> getTimetableItems(List<Semester> semesters) async {
    try {
      final api = apiClient.getTimetableItemsApi();
      final response = await api.timetableItemsV1List(
        semesters: BuiltList<DottoFoundationV1CourseSemester>(
          semesters.map(
            (e) => switch (e) {
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
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get timetable items');
      }
      final data = response.data;
      if (data == null) {
        throw DomainError(type: DomainErrorType.invalidResponse, message: 'Failed to get timetable items');
      }
      return data.timetableItems
          .map(
            (e) => TimetableItem(
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
              slot: () {
                final slot = e.slot;
                if (slot == null) return null;
                return TimetableSlot(
                  dayOfWeek: switch (slot.dayOfWeek) {
                    DottoFoundationV1DayOfWeek.monday => DayOfWeek.monday,
                    DottoFoundationV1DayOfWeek.tuesday => DayOfWeek.tuesday,
                    DottoFoundationV1DayOfWeek.wednesday => DayOfWeek.wednesday,
                    DottoFoundationV1DayOfWeek.thursday => DayOfWeek.thursday,
                    DottoFoundationV1DayOfWeek.friday => DayOfWeek.friday,
                    DottoFoundationV1DayOfWeek.saturday => DayOfWeek.saturday,
                    DottoFoundationV1DayOfWeek.sunday => DayOfWeek.sunday,
                    _ => throw DomainError(type: DomainErrorType.invalidData, message: 'Invalid day of week'),
                  },
                  period: switch (slot.period) {
                    DottoFoundationV1Period.period1 => Period.first,
                    DottoFoundationV1Period.period2 => Period.second,
                    DottoFoundationV1Period.period3 => Period.third,
                    DottoFoundationV1Period.period4 => Period.fourth,
                    DottoFoundationV1Period.period5 => Period.fifth,
                    DottoFoundationV1Period.period6 => Period.sixth,
                    _ => throw DomainError(type: DomainErrorType.invalidData, message: 'Invalid period'),
                  },
                );
              }(),
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
}
