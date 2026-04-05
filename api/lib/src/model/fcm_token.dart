//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fcm_token.g.dart';

/// FCMToken
///
/// Properties:
/// * [token] - FCMトークン
/// * [createdAt] - 作成日時
/// * [updatedAt] - 更新日時
@BuiltValue()
abstract class FCMToken implements Built<FCMToken, FCMTokenBuilder> {
  /// FCMトークン
  @BuiltValueField(wireName: r'token')
  String get token;

  /// 作成日時
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// 更新日時
  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  FCMToken._();

  factory FCMToken([void updates(FCMTokenBuilder b)]) = _$FCMToken;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FCMTokenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FCMToken> get serializer => _$FCMTokenSerializer();
}

class _$FCMTokenSerializer implements PrimitiveSerializer<FCMToken> {
  @override
  final Iterable<Type> types = const [FCMToken, _$FCMToken];

  @override
  final String wireName = r'FCMToken';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FCMToken object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FCMToken object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FCMTokenBuilder result,
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
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FCMToken deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FCMTokenBuilder();
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

