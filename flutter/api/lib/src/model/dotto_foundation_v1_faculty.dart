//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dotto_foundation_v1_faculty.g.dart';

/// 教員
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [email] 
@BuiltValue()
abstract class DottoFoundationV1Faculty implements Built<DottoFoundationV1Faculty, DottoFoundationV1FacultyBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  DottoFoundationV1Faculty._();

  factory DottoFoundationV1Faculty([void updates(DottoFoundationV1FacultyBuilder b)]) = _$DottoFoundationV1Faculty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DottoFoundationV1FacultyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DottoFoundationV1Faculty> get serializer => _$DottoFoundationV1FacultySerializer();
}

class _$DottoFoundationV1FacultySerializer implements PrimitiveSerializer<DottoFoundationV1Faculty> {
  @override
  final Iterable<Type> types = const [DottoFoundationV1Faculty, _$DottoFoundationV1Faculty];

  @override
  final String wireName = r'DottoFoundationV1Faculty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DottoFoundationV1Faculty object, {
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
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DottoFoundationV1Faculty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DottoFoundationV1FacultyBuilder result,
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
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DottoFoundationV1Faculty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DottoFoundationV1FacultyBuilder();
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

