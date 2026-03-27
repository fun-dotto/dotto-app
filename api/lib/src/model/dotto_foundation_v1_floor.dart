//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_floor.g.dart';

class DottoFoundationV1Floor extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Floor1')
  static const DottoFoundationV1Floor floor1 = _$floor1;
  @BuiltValueEnumConst(wireName: r'Floor2')
  static const DottoFoundationV1Floor floor2 = _$floor2;
  @BuiltValueEnumConst(wireName: r'Floor3')
  static const DottoFoundationV1Floor floor3 = _$floor3;
  @BuiltValueEnumConst(wireName: r'Floor4')
  static const DottoFoundationV1Floor floor4 = _$floor4;
  @BuiltValueEnumConst(wireName: r'Floor5')
  static const DottoFoundationV1Floor floor5 = _$floor5;
  @BuiltValueEnumConst(wireName: r'Floor6')
  static const DottoFoundationV1Floor floor6 = _$floor6;
  @BuiltValueEnumConst(wireName: r'Floor7')
  static const DottoFoundationV1Floor floor7 = _$floor7;

  static Serializer<DottoFoundationV1Floor> get serializer => _$dottoFoundationV1FloorSerializer;

  const DottoFoundationV1Floor._(String name): super(name);

  static BuiltSet<DottoFoundationV1Floor> get values => _$values;
  static DottoFoundationV1Floor valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1FloorMixin = Object with _$DottoFoundationV1FloorMixin;

