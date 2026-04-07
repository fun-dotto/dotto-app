//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/cancelled_class.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancelled_classes_v1_list200_response.g.dart';

/// CancelledClassesV1List200Response
///
/// Properties:
/// * [cancelledClasses] 
@BuiltValue()
abstract class CancelledClassesV1List200Response implements Built<CancelledClassesV1List200Response, CancelledClassesV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'cancelledClasses')
  BuiltList<CancelledClass> get cancelledClasses;

  CancelledClassesV1List200Response._();

  factory CancelledClassesV1List200Response([void updates(CancelledClassesV1List200ResponseBuilder b)]) = _$CancelledClassesV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancelledClassesV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancelledClassesV1List200Response> get serializer => _$CancelledClassesV1List200ResponseSerializer();
}

class _$CancelledClassesV1List200ResponseSerializer implements PrimitiveSerializer<CancelledClassesV1List200Response> {
  @override
  final Iterable<Type> types = const [CancelledClassesV1List200Response, _$CancelledClassesV1List200Response];

  @override
  final String wireName = r'CancelledClassesV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancelledClassesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cancelledClasses';
    yield serializers.serialize(
      object.cancelledClasses,
      specifiedType: const FullType(BuiltList, [FullType(CancelledClass)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancelledClassesV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancelledClassesV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cancelledClasses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CancelledClass)]),
          ) as BuiltList<CancelledClass>;
          result.cancelledClasses.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancelledClassesV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancelledClassesV1List200ResponseBuilder();
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

