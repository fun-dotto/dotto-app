enum SubjectRequirement {
  required,
  optional,
  optionalRequired;

  String get label => switch (this) {
    SubjectRequirement.required => '必修',
    SubjectRequirement.optional => '選択',
    SubjectRequirement.optionalRequired => '選択必修',
  };
}
