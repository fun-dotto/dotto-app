//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/personal_calendar_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'personal_calendar_items_v1_list200_response.g.dart';

/// PersonalCalendarItemsV1List200Response
///
/// Properties:
/// * [personalCalendarItems] 
@BuiltValue()
abstract class PersonalCalendarItemsV1List200Response implements Built<PersonalCalendarItemsV1List200Response, PersonalCalendarItemsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'personalCalendarItems')
  BuiltList<PersonalCalendarItem> get personalCalendarItems;

  PersonalCalendarItemsV1List200Response._();

  factory PersonalCalendarItemsV1List200Response([void updates(PersonalCalendarItemsV1List200ResponseBuilder b)]) = _$PersonalCalendarItemsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PersonalCalendarItemsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PersonalCalendarItemsV1List200Response> get serializer => _$PersonalCalendarItemsV1List200ResponseSerializer();
}

class _$PersonalCalendarItemsV1List200ResponseSerializer implements PrimitiveSerializer<PersonalCalendarItemsV1List200Response> {
  @override
  final Iterable<Type> types = const [PersonalCalendarItemsV1List200Response, _$PersonalCalendarItemsV1List200Response];

  @override
  final String wireName = r'PersonalCalendarItemsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PersonalCalendarItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'personalCalendarItems';
    yield serializers.serialize(
      object.personalCalendarItems,
      specifiedType: const FullType(BuiltList, [FullType(PersonalCalendarItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PersonalCalendarItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PersonalCalendarItemsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'personalCalendarItems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PersonalCalendarItem)]),
          ) as BuiltList<PersonalCalendarItem>;
          result.personalCalendarItems.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PersonalCalendarItemsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PersonalCalendarItemsV1List200ResponseBuilder();
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

