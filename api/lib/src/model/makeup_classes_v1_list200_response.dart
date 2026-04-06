//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/makeup_class.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'makeup_classes_v1_list200_response.g.dart';

/// MakeupClassesV1List200Response
///
/// Properties:
/// * [makeupClasses] 
@BuiltValue()
abstract class MakeupClassesV1List200Response implements Built<MakeupClassesV1List200Response, MakeupClassesV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'makeupClasses')
  BuiltList<MakeupClass> get makeupClasses;

  MakeupClassesV1List200Response._();

  factory MakeupClassesV1List200Response([void updates(MakeupClassesV1List200ResponseBuilder b)]) = _$MakeupClassesV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MakeupClassesV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MakeupClassesV1List200Response> get serializer => _$MakeupClassesV1List200ResponseSerializer();
}

class _$MakeupClassesV1List200ResponseSerializer implements PrimitiveSerializer<MakeupClassesV1List200Response> {
  @override
  final Iterable<Type> types = const [MakeupClassesV1List200Response, _$MakeupClassesV1List200Response];

  @override
  final String wireName = r'MakeupClassesV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MakeupClassesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'makeupClasses';
    yield serializers.serialize(
      object.makeupClasses,
      specifiedType: const FullType(BuiltList, [FullType(MakeupClass)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MakeupClassesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MakeupClassesV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'makeupClasses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MakeupClass)]),
          ) as BuiltList<MakeupClass>;
          result.makeupClasses.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MakeupClassesV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MakeupClassesV1List200ResponseBuilder();
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

