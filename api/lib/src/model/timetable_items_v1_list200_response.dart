//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/timetable_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'timetable_items_v1_list200_response.g.dart';

/// TimetableItemsV1List200Response
///
/// Properties:
/// * [timetableItems] 
@BuiltValue()
abstract class TimetableItemsV1List200Response implements Built<TimetableItemsV1List200Response, TimetableItemsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'timetableItems')
  BuiltList<TimetableItem> get timetableItems;

  TimetableItemsV1List200Response._();

  factory TimetableItemsV1List200Response([void updates(TimetableItemsV1List200ResponseBuilder b)]) = _$TimetableItemsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TimetableItemsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TimetableItemsV1List200Response> get serializer => _$TimetableItemsV1List200ResponseSerializer();
}

class _$TimetableItemsV1List200ResponseSerializer implements PrimitiveSerializer<TimetableItemsV1List200Response> {
  @override
  final Iterable<Type> types = const [TimetableItemsV1List200Response, _$TimetableItemsV1List200Response];

  @override
  final String wireName = r'TimetableItemsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TimetableItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'timetableItems';
    yield serializers.serialize(
      object.timetableItems,
      specifiedType: const FullType(BuiltList, [FullType(TimetableItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TimetableItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TimetableItemsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'timetableItems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TimetableItem)]),
          ) as BuiltList<TimetableItem>;
          result.timetableItems.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TimetableItemsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TimetableItemsV1List200ResponseBuilder();
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

