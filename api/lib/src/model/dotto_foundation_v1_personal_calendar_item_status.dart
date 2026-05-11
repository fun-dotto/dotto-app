//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_personal_calendar_item_status.g.dart';

class DottoFoundationV1PersonalCalendarItemStatus extends EnumClass {

  /// 教室変更よりも休講・補講が優先される
  @BuiltValueEnumConst(wireName: r'Normal')
  static const DottoFoundationV1PersonalCalendarItemStatus normal = _$normal;
  /// 教室変更よりも休講・補講が優先される
  @BuiltValueEnumConst(wireName: r'Cancelled')
  static const DottoFoundationV1PersonalCalendarItemStatus cancelled = _$cancelled;
  /// 教室変更よりも休講・補講が優先される
  @BuiltValueEnumConst(wireName: r'Makeup')
  static const DottoFoundationV1PersonalCalendarItemStatus makeup = _$makeup;
  /// 教室変更よりも休講・補講が優先される
  @BuiltValueEnumConst(wireName: r'RoomChanged')
  static const DottoFoundationV1PersonalCalendarItemStatus roomChanged = _$roomChanged;

  static Serializer<DottoFoundationV1PersonalCalendarItemStatus> get serializer => _$dottoFoundationV1PersonalCalendarItemStatusSerializer;

  const DottoFoundationV1PersonalCalendarItemStatus._(String name): super(name);

  static BuiltSet<DottoFoundationV1PersonalCalendarItemStatus> get values => _$values;
  static DottoFoundationV1PersonalCalendarItemStatus valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class DottoFoundationV1PersonalCalendarItemStatusMixin = Object with _$DottoFoundationV1PersonalCalendarItemStatusMixin;

