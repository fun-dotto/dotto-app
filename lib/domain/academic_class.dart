enum AcademicClass {
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
  i,
  j,
  k,
  l;

  String get label => switch (this) {
    AcademicClass.a => 'A',
    AcademicClass.b => 'B',
    AcademicClass.c => 'C',
    AcademicClass.d => 'D',
    AcademicClass.e => 'E',
    AcademicClass.f => 'F',
    AcademicClass.g => 'G',
    AcademicClass.h => 'H',
    AcademicClass.i => 'I',
    AcademicClass.j => 'J',
    AcademicClass.k => 'K',
    AcademicClass.l => 'L',
  };
}
