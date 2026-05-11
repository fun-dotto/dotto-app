//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'category.g.dart';

class Category extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SetAndSingle')
  static const Category setAndSingle = _$setAndSingle;
  @BuiltValueEnumConst(wireName: r'BowlAndCurry')
  static const Category bowlAndCurry = _$bowlAndCurry;
  @BuiltValueEnumConst(wireName: r'Noodle')
  static const Category noodle = _$noodle;
  @BuiltValueEnumConst(wireName: r'Side')
  static const Category side = _$side;
  @BuiltValueEnumConst(wireName: r'Dessert')
  static const Category dessert = _$dessert;

  static Serializer<Category> get serializer => _$categorySerializer;

  const Category._(String name): super(name);

  static BuiltSet<Category> get values => _$values;
  static Category valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class CategoryMixin = Object with _$CategoryMixin;

