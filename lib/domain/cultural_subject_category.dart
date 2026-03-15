enum CulturalSubjectCategory {
  society,
  human,
  science,
  health,
  communication;

  String get label => switch (this) {
    CulturalSubjectCategory.society => '社会',
    CulturalSubjectCategory.human => '人間',
    CulturalSubjectCategory.science => '科学',
    CulturalSubjectCategory.health => '健康',
    CulturalSubjectCategory.communication => 'コミュニケーション',
  };
}
