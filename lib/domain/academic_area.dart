import 'package:collection/collection.dart';

enum AcademicArea {
  // 学部コース
  informationSystemCourse,
  informationDesignCourse,
  complexCourse,
  intelligenceSystemCourse,
  advancedICTCourse,
  // 大学院領域
  informationArchitectureArea,
  mediaDesignArea,
  complexInformationScienceArea,
  intelligenceInformationScienceArea,
  advancedICTArea;

  String get label => switch (this) {
    AcademicArea.informationSystemCourse => '情報システムコース',
    AcademicArea.informationDesignCourse => '情報デザインコース',
    AcademicArea.complexCourse => '複雑系コース',
    AcademicArea.intelligenceSystemCourse => '知能システムコース',
    AcademicArea.advancedICTCourse => '高度ICTコース',
    AcademicArea.informationArchitectureArea => '情報アーキテクチャ領域',
    AcademicArea.mediaDesignArea => 'メディアデザイン領域',
    AcademicArea.complexInformationScienceArea => '複雑系情報科学領域',
    AcademicArea.intelligenceInformationScienceArea => '知能情報科学領域',
    AcademicArea.advancedICTArea => '高度ICT領域',
  };
  String? get deprecatedUserPreferenceKey => switch (this) {
    AcademicArea.informationSystemCourse => '情報システム',
    AcademicArea.informationDesignCourse => '情報デザイン',
    AcademicArea.complexCourse => '複雑',
    AcademicArea.intelligenceSystemCourse => '知能',
    AcademicArea.advancedICTCourse => '高度ICT',
    AcademicArea.informationArchitectureArea => null,
    AcademicArea.mediaDesignArea => null,
    AcademicArea.complexInformationScienceArea => null,
    AcademicArea.intelligenceInformationScienceArea => null,
    AcademicArea.advancedICTArea => null,
  };
  String? get deprecatedFilterOptionChoiceKey => switch (this) {
    AcademicArea.informationSystemCourse => '情報システムコース',
    AcademicArea.informationDesignCourse => '情報デザインコース',
    AcademicArea.complexCourse => '複雑系コース',
    AcademicArea.intelligenceSystemCourse => '知能システムコース',
    AcademicArea.advancedICTCourse => '高度ICTコース',
    AcademicArea.informationArchitectureArea => null,
    AcademicArea.mediaDesignArea => null,
    AcademicArea.complexInformationScienceArea => null,
    AcademicArea.intelligenceInformationScienceArea => null,
    AcademicArea.advancedICTArea => null,
  };

  static AcademicArea? fromDeprecatedUserPreferenceKey(String key) {
    return values.firstWhereOrNull((e) => e.deprecatedUserPreferenceKey == key);
  }
}
