//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/fcm_token.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fcm_token_v1_upsert200_response.g.dart';

/// FCMTokenV1Upsert200Response
///
/// Properties:
/// * [fcmToken] 
@BuiltValue()
abstract class FCMTokenV1Upsert200Response implements Built<FCMTokenV1Upsert200Response, FCMTokenV1Upsert200ResponseBuilder> {
  @BuiltValueField(wireName: r'fcmToken')
  FCMToken get fcmToken;

  FCMTokenV1Upsert200Response._();

  factory FCMTokenV1Upsert200Response([void updates(FCMTokenV1Upsert200ResponseBuilder b)]) = _$FCMTokenV1Upsert200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FCMTokenV1Upsert200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FCMTokenV1Upsert200Response> get serializer => _$FCMTokenV1Upsert200ResponseSerializer();
}

class _$FCMTokenV1Upsert200ResponseSerializer implements PrimitiveSerializer<FCMTokenV1Upsert200Response> {
  @override
  final Iterable<Type> types = const [FCMTokenV1Upsert200Response, _$FCMTokenV1Upsert200Response];

  @override
  final String wireName = r'FCMTokenV1Upsert200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FCMTokenV1Upsert200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fcmToken';
    yield serializers.serialize(
      object.fcmToken,
      specifiedType: const FullType(FCMToken),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FCMTokenV1Upsert200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FCMTokenV1Upsert200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fcmToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FCMToken),
          ) as FCMToken;
          result.fcmToken.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FCMTokenV1Upsert200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FCMTokenV1Upsert200ResponseBuilder();
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

