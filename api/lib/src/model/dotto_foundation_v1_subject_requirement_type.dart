//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_subject_requirement_type.g.dart';

class DottoFoundationV1SubjectRequirementType extends EnumClass {

  /// 必修・選択
  @BuiltValueEnumConst(wireName: r'Required')
  static const DottoFoundationV1SubjectRequirementType required_ = _$required_;
  /// 必修・選択
  @BuiltValueEnumConst(wireName: r'Optional')
  static const DottoFoundationV1SubjectRequirementType optional = _$optional;
  /// 必修・選択
  @BuiltValueEnumConst(wireName: r'OptionalRequired')
  static const DottoFoundationV1SubjectRequirementType optionalRequired = _$optionalRequired;

  static Serializer<DottoFoundationV1SubjectRequirementType> get serializer => _$dottoFoundationV1SubjectRequirementTypeSerializer;

  const DottoFoundationV1SubjectRequirementType._(String name): super(name);

  static BuiltSet<DottoFoundationV1SubjectRequirementType> get values => _$values;
  static DottoFoundationV1SubjectRequirementType valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1SubjectRequirementTypeMixin = Object with _$DottoFoundationV1SubjectRequirementTypeMixin;

