import 'package:dotto/domain/semester.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Semester.isActiveAt', () {
    group('前期 (H1)', () {
      test('4月はアクティブ', () {
        expect(Semester.h1.isActiveAt(DateTime(2026, 4, 1)), isTrue);
      });

      test('9月はアクティブ', () {
        expect(Semester.h1.isActiveAt(DateTime(2026, 9, 30)), isTrue);
      });

      test('10月は非アクティブ', () {
        expect(Semester.h1.isActiveAt(DateTime(2026, 10, 1)), isFalse);
      });

      test('3月は非アクティブ', () {
        expect(Semester.h1.isActiveAt(DateTime(2026, 3, 31)), isFalse);
      });
    });

    group('後期 (H2)', () {
      test('10月はアクティブ', () {
        expect(Semester.h2.isActiveAt(DateTime(2026, 10, 1)), isTrue);
      });

      test('3月はアクティブ', () {
        expect(Semester.h2.isActiveAt(DateTime(2027, 3, 31)), isTrue);
      });

      test('4月は非アクティブ', () {
        expect(Semester.h2.isActiveAt(DateTime(2026, 4, 1)), isFalse);
      });

      test('9月は非アクティブ', () {
        expect(Semester.h2.isActiveAt(DateTime(2026, 9, 30)), isFalse);
      });
    });

    group('通年 (AllYear)', () {
      test('すべての月でアクティブ', () {
        for (var month = 1; month <= 12; month++) {
          expect(Semester.allYear.isActiveAt(DateTime(2026, month, 1)), isTrue, reason: '$month月');
        }
      });
    });

    group('第1クォータ (Q1)', () {
      test('4月はアクティブ', () {
        expect(Semester.q1.isActiveAt(DateTime(2026, 4, 1)), isTrue);
      });

      test('6月はアクティブ', () {
        expect(Semester.q1.isActiveAt(DateTime(2026, 6, 30)), isTrue);
      });

      test('7月は非アクティブ', () {
        expect(Semester.q1.isActiveAt(DateTime(2026, 7, 1)), isFalse);
      });
    });

    group('第2クォータ (Q2)', () {
      test('7月はアクティブ', () {
        expect(Semester.q2.isActiveAt(DateTime(2026, 7, 1)), isTrue);
      });

      test('9月はアクティブ', () {
        expect(Semester.q2.isActiveAt(DateTime(2026, 9, 30)), isTrue);
      });

      test('10月は非アクティブ', () {
        expect(Semester.q2.isActiveAt(DateTime(2026, 10, 1)), isFalse);
      });
    });

    group('第3クォータ (Q3)', () {
      test('10月はアクティブ', () {
        expect(Semester.q3.isActiveAt(DateTime(2026, 10, 1)), isTrue);
      });

      test('12月はアクティブ', () {
        expect(Semester.q3.isActiveAt(DateTime(2026, 12, 31)), isTrue);
      });

      test('1月は非アクティブ', () {
        expect(Semester.q3.isActiveAt(DateTime(2027, 1, 1)), isFalse);
      });
    });

    group('第4クォータ (Q4)', () {
      test('1月はアクティブ', () {
        expect(Semester.q4.isActiveAt(DateTime(2027, 1, 1)), isTrue);
      });

      test('3月はアクティブ', () {
        expect(Semester.q4.isActiveAt(DateTime(2027, 3, 31)), isTrue);
      });

      test('4月は非アクティブ', () {
        expect(Semester.q4.isActiveAt(DateTime(2026, 4, 1)), isFalse);
      });
    });

    group('夏期集中', () {
      test('8月はアクティブ', () {
        expect(Semester.summerIntensive.isActiveAt(DateTime(2026, 8, 1)), isTrue);
      });

      test('9月はアクティブ', () {
        expect(Semester.summerIntensive.isActiveAt(DateTime(2026, 9, 30)), isTrue);
      });

      test('7月は非アクティブ', () {
        expect(Semester.summerIntensive.isActiveAt(DateTime(2026, 7, 31)), isFalse);
      });
    });

    group('冬期集中', () {
      test('2月はアクティブ', () {
        expect(Semester.winterIntensive.isActiveAt(DateTime(2027, 2, 1)), isTrue);
      });

      test('3月はアクティブ', () {
        expect(Semester.winterIntensive.isActiveAt(DateTime(2027, 3, 31)), isTrue);
      });

      test('1月は非アクティブ', () {
        expect(Semester.winterIntensive.isActiveAt(DateTime(2027, 1, 31)), isFalse);
      });
    });
  });

  group('Semester.getActiveSemesters', () {
    test('4月は H1, Q1 がアクティブ', () {
      final active = Semester.getActiveSemesters(DateTime(2026, 4, 1));
      expect(active, containsAll([Semester.h1, Semester.allYear, Semester.q1]));
      expect(active, isNot(contains(Semester.h2)));
    });

    test('10月は H2, Q3 がアクティブ', () {
      final active = Semester.getActiveSemesters(DateTime(2026, 10, 1));
      expect(active, containsAll([Semester.h2, Semester.allYear, Semester.q3]));
      expect(active, isNot(contains(Semester.h1)));
    });

    test('8月は H1, Q2, 夏期集中がアクティブ', () {
      final active = Semester.getActiveSemesters(DateTime(2026, 8, 1));
      expect(active, containsAll([Semester.h1, Semester.allYear, Semester.q2, Semester.summerIntensive]));
    });
  });
}
