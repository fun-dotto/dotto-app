import 'package:collection/collection.dart';

enum AcademicArea {
  // 学部コース
  informationSystemCourse,
  informationDesignCourse,
  complexCourse,
  intelligenceSystemCourse,
  advancedICTCourse;

  String get label => switch (this) {
    AcademicArea.informationSystemCourse => '情報システムコース',
    AcademicArea.informationDesignCourse => '情報デザインコース',
    AcademicArea.complexCourse => '複雑系コース',
    AcademicArea.intelligenceSystemCourse => '知能システムコース',
    AcademicArea.advancedICTCourse => '高度ICTコース',
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
