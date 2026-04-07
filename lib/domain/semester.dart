enum Semester {
  h1,
  h2,
  allYear,
  q1,
  q2,
  q3,
  q4,
  summerIntensive,
  winterIntensive;

  String get label => switch (this) {
    Semester.h1 => '前期',
    Semester.h2 => '後期',
    Semester.allYear => '通年',
    Semester.q1 => '第1クォータ',
    Semester.q2 => '第2クォータ',
    Semester.q3 => '第3クォータ',
    Semester.q4 => '第4クォータ',
    Semester.summerIntensive => '夏期集中',
    Semester.winterIntensive => '冬期集中',
  };

  /// 指定された日付が、このセメスターに該当するかどうかを判定する
  bool isActiveAt(DateTime date) {
    return switch (this) {
      Semester.h1 => date.month >= 4 && date.month <= 9,
      Semester.h2 => date.month >= 10 || date.month <= 3,
      Semester.allYear => true,
      Semester.q1 => date.month >= 4 && date.month <= 7,
      Semester.q2 => date.month >= 7 && date.month <= 9,
      Semester.q3 => date.month >= 10 && date.month <= 1,
      Semester.q4 => date.month >= 1 && date.month <= 3,
      Semester.summerIntensive => date.month >= 7 && date.month <= 9,
      Semester.winterIntensive => date.month >= 1 && date.month <= 3,
    };
  }

  /// 指定された日付から、現在アクティブなセメスターのリストを取得する
  static List<Semester> getActiveSemesters(DateTime date) {
    return Semester.values.where((semester) => semester.isActiveAt(date)).toList();
  }
}
