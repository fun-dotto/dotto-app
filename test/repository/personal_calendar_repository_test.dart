import 'package:dotto/domain/lecture_status.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openapi/openapi.dart';

void main() {
  group('toPeriod', () {
    test('period1 を Period.first にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period1), Period.first);
    });

    test('period2 を Period.second にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period2), Period.second);
    });

    test('period3 を Period.third にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period3), Period.third);
    });

    test('period4 を Period.fourth にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period4), Period.fourth);
    });

    test('period5 を Period.fifth にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period5), Period.fifth);
    });

    test('period6 を Period.sixth にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toPeriod(DottoFoundationV1Period.period6), Period.sixth);
    });
  });

  group('toLectureStatus', () {
    test('cancelled を LectureStatus.cancelled にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toLectureStatus(DottoFoundationV1PersonalCalendarItemStatus.cancelled),
        LectureStatus.cancelled,
      );
    });

    test('makeup を LectureStatus.madeUp にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toLectureStatus(DottoFoundationV1PersonalCalendarItemStatus.makeup),
        LectureStatus.madeUp,
      );
    });

    test('normal を LectureStatus.normal にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toLectureStatus(DottoFoundationV1PersonalCalendarItemStatus.normal),
        LectureStatus.normal,
      );
    });

    test('roomChanged を LectureStatus.roomChanged にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toLectureStatus(DottoFoundationV1PersonalCalendarItemStatus.roomChanged),
        LectureStatus.roomChanged,
      );
    });
  });

  group('toSemester', () {
    test('h1 を Semester.h1 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.h1), Semester.h1);
    });

    test('h2 を Semester.h2 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.h2), Semester.h2);
    });

    test('allYear を Semester.allYear にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.allYear), Semester.allYear);
    });

    test('q1 を Semester.q1 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.q1), Semester.q1);
    });

    test('q2 を Semester.q2 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.q2), Semester.q2);
    });

    test('q3 を Semester.q3 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.q3), Semester.q3);
    });

    test('q4 を Semester.q4 にマッピングする', () {
      expect(PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.q4), Semester.q4);
    });

    test('summerIntensive を Semester.summerIntensive にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.summerIntensive),
        Semester.summerIntensive,
      );
    });

    test('winterIntensive を Semester.winterIntensive にマッピングする', () {
      expect(
        PersonalCalendarRepositoryImpl.toSemester(DottoFoundationV1CourseSemester.winterIntensive),
        Semester.winterIntensive,
      );
    });
  });
}
