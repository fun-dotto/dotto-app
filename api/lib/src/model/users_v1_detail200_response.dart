//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/user_info.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'users_v1_detail200_response.g.dart';

/// UsersV1Detail200Response
///
/// Properties:
/// * [user] 
@BuiltValue()
abstract class UsersV1Detail200Response implements Built<UsersV1Detail200Response, UsersV1Detail200ResponseBuilder> {
  @BuiltValueField(wireName: r'user')
  UserInfo get user;

  UsersV1Detail200Response._();

  factory UsersV1Detail200Response([void updates(UsersV1Detail200ResponseBuilder b)]) = _$UsersV1Detail200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UsersV1Detail200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UsersV1Detail200Response> get serializer => _$UsersV1Detail200ResponseSerializer();
}

class _$UsersV1Detail200ResponseSerializer implements PrimitiveSerializer<UsersV1Detail200Response> {
  @override
  final Iterable<Type> types = const [UsersV1Detail200Response, _$UsersV1Detail200Response];

  @override
  final String wireName = r'UsersV1Detail200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UsersV1Detail200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserInfo),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UsersV1Detail200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UsersV1Detail200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserInfo),
          ) as UserInfo;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UsersV1Detail200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UsersV1Detail200ResponseBuilder();
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

