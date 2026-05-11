//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/room_change.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'room_changes_v1_list200_response.g.dart';

/// RoomChangesV1List200Response
///
/// Properties:
/// * [roomChanges] 
@BuiltValue()
abstract class RoomChangesV1List200Response implements Built<RoomChangesV1List200Response, RoomChangesV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'roomChanges')
  BuiltList<RoomChange> get roomChanges;

  RoomChangesV1List200Response._();

  factory RoomChangesV1List200Response([void updates(RoomChangesV1List200ResponseBuilder b)]) = _$RoomChangesV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoomChangesV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoomChangesV1List200Response> get serializer => _$RoomChangesV1List200ResponseSerializer();
}

class _$RoomChangesV1List200ResponseSerializer implements PrimitiveSerializer<RoomChangesV1List200Response> {
  @override
  final Iterable<Type> types = const [RoomChangesV1List200Response, _$RoomChangesV1List200Response];

  @override
  final String wireName = r'RoomChangesV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoomChangesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'roomChanges';
    yield serializers.serialize(
      object.roomChanges,
      specifiedType: const FullType(BuiltList, [FullType(RoomChange)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoomChangesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoomChangesV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'roomChanges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoomChange)]),
          ) as BuiltList<RoomChange>;
          result.roomChanges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoomChangesV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoomChangesV1List200ResponseBuilder();
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

