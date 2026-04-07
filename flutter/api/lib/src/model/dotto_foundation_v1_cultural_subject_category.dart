//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_cultural_subject_category.g.dart';

class DottoFoundationV1CulturalSubjectCategory extends EnumClass {

  /// 教養科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Society')
  static const DottoFoundationV1CulturalSubjectCategory society = _$society;
  /// 教養科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Human')
  static const DottoFoundationV1CulturalSubjectCategory human = _$human;
  /// 教養科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Science')
  static const DottoFoundationV1CulturalSubjectCategory science = _$science;
  /// 教養科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Health')
  static const DottoFoundationV1CulturalSubjectCategory health = _$health;
  /// 教養科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Communication')
  static const DottoFoundationV1CulturalSubjectCategory communication = _$communication;

  static Serializer<DottoFoundationV1CulturalSubjectCategory> get serializer => _$dottoFoundationV1CulturalSubjectCategorySerializer;

  const DottoFoundationV1CulturalSubjectCategory._(String name): super(name);

  static BuiltSet<DottoFoundationV1CulturalSubjectCategory> get values => _$values;
  static DottoFoundationV1CulturalSubjectCategory valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1CulturalSubjectCategoryMixin = Object with _$DottoFoundationV1CulturalSubjectCategoryMixin;

