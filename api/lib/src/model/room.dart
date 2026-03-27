//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_floor.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'room.g.dart';

/// Room
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [floor] 
@BuiltValue()
abstract class Room implements Built<Room, RoomBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'floor')
  DottoFoundationV1Floor get floor;
  // enum floorEnum {  Floor1,  Floor2,  Floor3,  Floor4,  Floor5,  Floor6,  Floor7,  };

  Room._();

  factory Room([void updates(RoomBuilder b)]) = _$Room;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoomBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Room> get serializer => _$RoomSerializer();
}

class _$RoomSerializer implements PrimitiveSerializer<Room> {
  @override
  final Iterable<Type> types = const [Room, _$Room];

  @override
  final String wireName = r'Room';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Room object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'floor';
    yield serializers.serialize(
      object.floor,
      specifiedType: const FullType(DottoFoundationV1Floor),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Room object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoomBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'floor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Floor),
          ) as DottoFoundationV1Floor;
          result.floor = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Room deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomBuilder();
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

