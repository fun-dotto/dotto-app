//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'size.g.dart';

class Size extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Small')
  static const Size small = _$small;
  @BuiltValueEnumConst(wireName: r'Medium')
  static const Size medium = _$medium;
  @BuiltValueEnumConst(wireName: r'Large')
  static const Size large = _$large;

  static Serializer<Size> get serializer => _$sizeSerializer;

  const Size._(String name): super(name);

  static BuiltSet<Size> get values => _$values;
  static Size valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SizeMixin = Object with _$SizeMixin;

