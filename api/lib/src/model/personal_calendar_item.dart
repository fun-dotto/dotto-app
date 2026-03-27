//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/timetable_item.dart';
import 'package:openapi/src/model/dotto_foundation_v1_timetable_slot.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'personal_calendar_item.g.dart';

/// PersonalCalendarItem
///
/// Properties:
/// * [date] 
/// * [slot] 
/// * [timetableItem] 
@BuiltValue()
abstract class PersonalCalendarItem implements Built<PersonalCalendarItem, PersonalCalendarItemBuilder> {
  @BuiltValueField(wireName: r'date')
  DateTime get date;

  @BuiltValueField(wireName: r'slot')
  DottoFoundationV1TimetableSlot get slot;

  @BuiltValueField(wireName: r'timetableItem')
  TimetableItem get timetableItem;

  PersonalCalendarItem._();

  factory PersonalCalendarItem([void updates(PersonalCalendarItemBuilder b)]) = _$PersonalCalendarItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonalCalendarItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonalCalendarItem> get serializer => _$PersonalCalendarItemSerializer();
}

class _$PersonalCalendarItemSerializer implements PrimitiveSerializer<PersonalCalendarItem> {
  @override
  final Iterable<Type> types = const [PersonalCalendarItem, _$PersonalCalendarItem];

  @override
  final String wireName = r'PersonalCalendarItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonalCalendarItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(DateTime),
    );
    yield r'slot';
    yield serializers.serialize(
      object.slot,
      specifiedType: const FullType(DottoFoundationV1TimetableSlot),
    );
    yield r'timetableItem';
    yield serializers.serialize(
      object.timetableItem,
      specifiedType: const FullType(TimetableItem),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonalCalendarItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonalCalendarItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.date = valueDes;
          break;
        case r'slot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1TimetableSlot),
          ) as DottoFoundationV1TimetableSlot;
          result.slot.replace(valueDes);
          break;
        case r'timetableItem':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(TimetableItem),
          ) as TimetableItem;
          result.timetableItem.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonalCalendarItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonalCalendarItemBuilder();
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

