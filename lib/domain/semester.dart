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
}
