//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/room.dart';
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/dotto_foundation_v1_timetable_slot.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'timetable_item.g.dart';

/// TimetableItem
///
/// Properties:
/// * [id] 
/// * [subject] 
/// * [slot] - 集中講義など、時間割に含まれていない場合はnull
/// * [rooms] 
@BuiltValue()
abstract class TimetableItem implements Built<TimetableItem, TimetableItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject')
  SubjectSummary get subject;

  /// 集中講義など、時間割に含まれていない場合はnull
  @BuiltValueField(wireName: r'slot')
  DottoFoundationV1TimetableSlot? get slot;

  @BuiltValueField(wireName: r'rooms')
  BuiltList<Room> get rooms;

  TimetableItem._();

  factory TimetableItem([void updates(TimetableItemBuilder b)]) = _$TimetableItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TimetableItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TimetableItem> get serializer => _$TimetableItemSerializer();
}

class _$TimetableItemSerializer implements PrimitiveSerializer<TimetableItem> {
  @override
  final Iterable<Type> types = const [TimetableItem, _$TimetableItem];

  @override
  final String wireName = r'TimetableItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TimetableItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'subject';
    yield serializers.serialize(
      object.subject,
      specifiedType: const FullType(SubjectSummary),
    );
    if (object.slot != null) {
      yield r'slot';
      yield serializers.serialize(
        object.slot,
        specifiedType: const FullType(DottoFoundationV1TimetableSlot),
      );
    }
    yield r'rooms';
    yield serializers.serialize(
      object.rooms,
      specifiedType: const FullType(BuiltList, [FullType(Room)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TimetableItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TimetableItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SubjectSummary),
          ) as SubjectSummary;
          result.subject.replace(valueDes);
          break;
        case r'slot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1TimetableSlot),
          ) as DottoFoundationV1TimetableSlot;
          result.slot.replace(valueDes);
          break;
        case r'rooms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Room)]),
          ) as BuiltList<Room>;
          result.rooms.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TimetableItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TimetableItemBuilder();
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

