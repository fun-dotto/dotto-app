//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_period.g.dart';

class DottoFoundationV1Period extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Period1')
  static const DottoFoundationV1Period period1 = _$period1;
  @BuiltValueEnumConst(wireName: r'Period2')
  static const DottoFoundationV1Period period2 = _$period2;
  @BuiltValueEnumConst(wireName: r'Period3')
  static const DottoFoundationV1Period period3 = _$period3;
  @BuiltValueEnumConst(wireName: r'Period4')
  static const DottoFoundationV1Period period4 = _$period4;
  @BuiltValueEnumConst(wireName: r'Period5')
  static const DottoFoundationV1Period period5 = _$period5;
  @BuiltValueEnumConst(wireName: r'Period6')
  static const DottoFoundationV1Period period6 = _$period6;

  static Serializer<DottoFoundationV1Period> get serializer => _$dottoFoundationV1PeriodSerializer;

  const DottoFoundationV1Period._(String name): super(name);

  static BuiltSet<DottoFoundationV1Period> get values => _$values;
  static DottoFoundationV1Period valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1PeriodMixin = Object with _$DottoFoundationV1PeriodMixin;

