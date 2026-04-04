//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/room.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/dotto_foundation_v1_personal_calendar_item_status.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'personal_calendar_item.g.dart';

/// PersonalCalendarItem
///
/// Properties:
/// * [date] 
/// * [period] 
/// * [subject] 
/// * [rooms] 
/// * [status] 
@BuiltValue()
abstract class PersonalCalendarItem implements Built<PersonalCalendarItem, PersonalCalendarItemBuilder> {
  @BuiltValueField(wireName: r'date')
  DateTime get date;

  @BuiltValueField(wireName: r'period')
  DottoFoundationV1Period get period;
  // enum periodEnum {  Period1,  Period2,  Period3,  Period4,  Period5,  Period6,  };

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  @BuiltValueField(wireName: r'rooms')
  BuiltList<Room> get rooms;

  @BuiltValueField(wireName: r'status')
  DottoFoundationV1PersonalCalendarItemStatus get status;
  // enum statusEnum {  Normal,  Cancelled,  Makeup,  RoomChanged,  };

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
    yield r'period';
    yield serializers.serialize(
      object.period,
      specifiedType: const FullType(DottoFoundationV1Period),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(SubjectSummary),
    );
    yield r'rooms';
    yield serializers.serialize(
      object.rooms,
      specifiedType: const FullType(BuiltList, [FullType(Room)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DottoFoundationV1PersonalCalendarItemStatus),
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
        case r'period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Period),
          ) as DottoFoundationV1Period;
          result.period = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectSummary),
          ) as SubjectSummary;
          result.subject.replace(valueDes);
          break;
        case r'rooms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Room)]),
          ) as BuiltList<Room>;
          result.rooms.replace(valueDes);
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1PersonalCalendarItemStatus),
          ) as DottoFoundationV1PersonalCalendarItemStatus;
          result.status = valueDes;
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

