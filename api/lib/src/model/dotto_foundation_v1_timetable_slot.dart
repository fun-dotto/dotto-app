//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/dotto_foundation_v1_day_of_week.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_timetable_slot.g.dart';

/// DottoFoundationV1TimetableSlot
///
/// Properties:
/// * [dayOfWeek] 
/// * [period] 
@BuiltValue()
abstract class DottoFoundationV1TimetableSlot implements Built<DottoFoundationV1TimetableSlot, DottoFoundationV1TimetableSlotBuilder> {
  @BuiltValueField(wireName: r'dayOfWeek')
  DottoFoundationV1DayOfWeek get dayOfWeek;
  // enum dayOfWeekEnum {  Sunday,  Monday,  Tuesday,  Wednesday,  Thursday,  Friday,  Saturday,  };

  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  DottoFoundationV1TimetableSlot._();

  factory DottoFoundationV1TimetableSlot([void updates(DottoFoundationV1TimetableSlotBuilder b)]) = _$DottoFoundationV1TimetableSlot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DottoFoundationV1TimetableSlotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DottoFoundationV1TimetableSlot> get serializer => _$DottoFoundationV1TimetableSlotSerializer();
}

class _$DottoFoundationV1TimetableSlotSerializer implements PrimitiveSerializer<DottoFoundationV1TimetableSlot> {
  @override
  final Iterable<Type> types = const [DottoFoundationV1TimetableSlot, _$DottoFoundationV1TimetableSlot];

  @override
  final String wireName = r'DottoFoundationV1TimetableSlot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DottoFoundationV1TimetableSlot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dayOfWeek';
    yield serializers.serialize(
      object.dayOfWeek,
      specifiedType: const FullType(DottoFoundationV1DayOfWeek),
    );
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(DottoFoundationV1Period),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DottoFoundationV1TimetableSlot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DottoFoundationV1TimetableSlotBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dayOfWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1DayOfWeek),
          ) as DottoFoundationV1DayOfWeek;
          result.dayOfWeek = valueDes;
          break;
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Period),
          ) as DottoFoundationV1Period;
          result.period = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DottoFoundationV1TimetableSlot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DottoFoundationV1TimetableSlotBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

