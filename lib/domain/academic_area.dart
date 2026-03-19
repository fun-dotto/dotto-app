import 'package:collection/collection.dart';

enum AcademicArea {
  informationSystemCourse,
  informationDesignCourse,
  complexCourse,
  intelligenceSystemCourse,
  advancedICTCourse;

  String get label => switch (this) {
    AcademicArea.informationSystemCourse => '情報システム/情報アーキテクチャ',
    AcademicArea.informationDesignCourse => '情報デザイン/メディアデザイン',
    AcademicArea.complexCourse => '複雑系/複雑系情報科学',
    AcademicArea.intelligenceSystemCourse => '知能システム/知能情報科学',
    AcademicArea.advancedICTCourse => '高度ICT',
  };
  String? get deprecatedUserPreferenceKey => switch (this) {
    AcademicArea.informationSystemCourse => '情報システム',
    AcademicArea.informationDesignCourse => '情報デザイン',
    AcademicArea.complexCourse => '複雑',
    AcademicArea.intelligenceSystemCourse => '知能',
    AcademicArea.advancedICTCourse => '高度ICT',
  };
  String? get deprecatedFilterOptionChoiceKey => switch (this) {
    AcademicArea.informationSystemCourse => '情報システムコース',
    AcademicArea.informationDesignCourse => '情報デザインコース',
    AcademicArea.complexCourse => '複雑系コース',
    AcademicArea.intelligenceSystemCourse => '知能システムコース',
    AcademicArea.advancedICTCourse => '高度ICTコース',
  };

  static AcademicArea? fromDeprecatedUserPreferenceKey(String key) {
    return values.firstWhereOrNull((e) => e.deprecatedUserPreferenceKey == key);
  }
}
