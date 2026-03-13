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
    Semester.q1 => '第1クウォーター',
    Semester.q2 => '第2クウォーター',
    Semester.q3 => '第3クウォーター',
    Semester.q4 => '第4クウォーター',
    Semester.summerIntensive => '夏期集中',
    Semester.winterIntensive => '冬期集中',
  };

  @Deprecated('syllabus.dbで使用')
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
