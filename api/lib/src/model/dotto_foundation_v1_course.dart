//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_course.g.dart';

class DottoFoundationV1Course extends EnumClass {

  /// コース
  @BuiltValueEnumConst(wireName: r'InformationSystem')
  static const DottoFoundationV1Course informationSystem = _$informationSystem;
  /// コース
  @BuiltValueEnumConst(wireName: r'InformationDesign')
  static const DottoFoundationV1Course informationDesign = _$informationDesign;
  /// コース
  @BuiltValueEnumConst(wireName: r'AdvancedICT')
  static const DottoFoundationV1Course advancedICT = _$advancedICT;
  /// コース
  @BuiltValueEnumConst(wireName: r'ComplexSystem')
  static const DottoFoundationV1Course complexSystem = _$complexSystem;
  /// コース
  @BuiltValueEnumConst(wireName: r'IntelligentSystem')
  static const DottoFoundationV1Course intelligentSystem = _$intelligentSystem;

  static Serializer<DottoFoundationV1Course> get serializer => _$dottoFoundationV1CourseSerializer;

  const DottoFoundationV1Course._(String name): super(name);

  static BuiltSet<DottoFoundationV1Course> get values => _$values;
  static DottoFoundationV1Course valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1CourseMixin = Object with _$DottoFoundationV1CourseMixin;

