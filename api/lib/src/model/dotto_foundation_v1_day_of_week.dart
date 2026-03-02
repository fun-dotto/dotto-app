//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_day_of_week.g.dart';

class DottoFoundationV1DayOfWeek extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Sunday')
  static const DottoFoundationV1DayOfWeek sunday = _$sunday;
  @BuiltValueEnumConst(wireName: r'Monday')
  static const DottoFoundationV1DayOfWeek monday = _$monday;
  @BuiltValueEnumConst(wireName: r'Tuesday')
  static const DottoFoundationV1DayOfWeek tuesday = _$tuesday;
  @BuiltValueEnumConst(wireName: r'Wednesday')
  static const DottoFoundationV1DayOfWeek wednesday = _$wednesday;
  @BuiltValueEnumConst(wireName: r'Thursday')
  static const DottoFoundationV1DayOfWeek thursday = _$thursday;
  @BuiltValueEnumConst(wireName: r'Friday')
  static const DottoFoundationV1DayOfWeek friday = _$friday;
  @BuiltValueEnumConst(wireName: r'Saturday')
  static const DottoFoundationV1DayOfWeek saturday = _$saturday;

  static Serializer<DottoFoundationV1DayOfWeek> get serializer => _$dottoFoundationV1DayOfWeekSerializer;

  const DottoFoundationV1DayOfWeek._(String name): super(name);

  static BuiltSet<DottoFoundationV1DayOfWeek> get values => _$values;
  static DottoFoundationV1DayOfWeek valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1DayOfWeekMixin = Object with _$DottoFoundationV1DayOfWeekMixin;

