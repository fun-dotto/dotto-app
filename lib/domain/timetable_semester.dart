import 'package:dotto/domain/semester.dart';

enum TimetableSemester {
  spring,
  fall;

  String get label => switch (this) {
    TimetableSemester.spring => '前期',
    TimetableSemester.fall => '後期',
  };

  List<Semester> get semesters => switch (this) {
    TimetableSemester.spring => [
      Semester.h1,
      Semester.allYear,
      Semester.q1,
      Semester.q2,
      Semester.summerIntensive,
    ],
    TimetableSemester.fall => [
      Semester.h2,
      Semester.allYear,
      Semester.q3,
      Semester.q4,
      Semester.winterIntensive,
    ],
  };

  // Legacy: syllabus.dbで使用。移行完了までは削除しないこと。
  int get number {
    switch (this) {
      case TimetableSemester.spring:
        return 10;
      case TimetableSemester.fall:
        return 20;
    }
  }
}
