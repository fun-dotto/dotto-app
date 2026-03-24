enum SubjectRequirementType {
  required,
  optional,
  optionalRequired;

  String get label => switch (this) {
    SubjectRequirementType.required => '必修',
    SubjectRequirementType.optional => '選択',
    SubjectRequirementType.optionalRequired => '選択必修',
  };
}
