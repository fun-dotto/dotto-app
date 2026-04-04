//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fcm_token_request.g.dart';

/// FCMTokenRequest
///
/// Properties:
/// * [token] 
@BuiltValue()
abstract class FCMTokenRequest implements Built<FCMTokenRequest, FCMTokenRequestBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  FCMTokenRequest._();

  factory FCMTokenRequest([void updates(FCMTokenRequestBuilder b)]) = _$FCMTokenRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FCMTokenRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FCMTokenRequest> get serializer => _$FCMTokenRequestSerializer();
}

class _$FCMTokenRequestSerializer implements PrimitiveSerializer<FCMTokenRequest> {
  @override
  final Iterable<Type> types = const [FCMTokenRequest, _$FCMTokenRequest];

  @override
  final String wireName = r'FCMTokenRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FCMTokenRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FCMTokenRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FCMTokenRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FCMTokenRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FCMTokenRequestBuilder();
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

