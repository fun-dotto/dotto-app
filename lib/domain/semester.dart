enum Semester {
  spring,
  fall,
  allYear,
  q1,
  q2,
  q3,
  q4,
  summerIntensive,
  winterIntensive;

  String get label => switch (this) {
    Semester.spring => '前期',
    Semester.fall => '後期',
    Semester.allYear => '通年',
    Semester.q1 => '第1クォータ',
    Semester.q2 => '第2クォータ',
    Semester.q3 => '第3クォータ',
    Semester.q4 => '第4クォータ',
    Semester.summerIntensive => '夏期集中',
    Semester.winterIntensive => '冬期集中',
  };

  // Legacy: syllabus.dbで使用。移行完了までは削除しないこと。
  int get number {
    switch (this) {
      case Semester.spring:
        return 10;
      case Semester.fall:
        return 20;
      default:
        return 0;
    }
  }

  static List<Semester> get onEditTimetableScreen => [spring, fall];
}
