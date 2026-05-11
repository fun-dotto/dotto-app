//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_subject_classification.g.dart';

class DottoFoundationV1SubjectClassification extends EnumClass {

  /// 科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Specialized')
  static const DottoFoundationV1SubjectClassification specialized = _$specialized;
  /// 科目カテゴリ
  @BuiltValueEnumConst(wireName: r'Cultural')
  static const DottoFoundationV1SubjectClassification cultural = _$cultural;
  /// 科目カテゴリ
  @BuiltValueEnumConst(wireName: r'ResearchInstruction')
  static const DottoFoundationV1SubjectClassification researchInstruction = _$researchInstruction;

  static Serializer<DottoFoundationV1SubjectClassification> get serializer => _$dottoFoundationV1SubjectClassificationSerializer;

  const DottoFoundationV1SubjectClassification._(String name): super(name);

  static BuiltSet<DottoFoundationV1SubjectClassification> get values => _$values;
  static DottoFoundationV1SubjectClassification valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1SubjectClassificationMixin = Object with _$DottoFoundationV1SubjectClassificationMixin;

