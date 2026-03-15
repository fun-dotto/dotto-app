enum SubjectClassification {
  // 学部・大学院共通
  specialized,
  // 学部のみ
  cultural,
  // 大学院のみ
  researchInstruction;

  String get label => switch (this) {
    SubjectClassification.specialized => '専門',
    SubjectClassification.cultural => '教養',
    SubjectClassification.researchInstruction => '研究指導',
  };
}
