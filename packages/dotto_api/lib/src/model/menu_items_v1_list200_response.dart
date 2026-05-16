//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:openapi/src/model/menu_item.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'menu_items_v1_list200_response.g.dart';

/// MenuItemsV1List200Response
///
/// Properties:
/// * [menuItems] 
@BuiltValue()
abstract class MenuItemsV1List200Response implements Built<MenuItemsV1List200Response, MenuItemsV1List200ResponseBuilder> {
  @BuiltValueField(wireName: r'menuItems')
  BuiltList<MenuItem> get menuItems;

  MenuItemsV1List200Response._();

  factory MenuItemsV1List200Response([void updates(MenuItemsV1List200ResponseBuilder b)]) = _$MenuItemsV1List200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MenuItemsV1List200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MenuItemsV1List200Response> get serializer => _$MenuItemsV1List200ResponseSerializer();
}

class _$MenuItemsV1List200ResponseSerializer implements PrimitiveSerializer<MenuItemsV1List200Response> {
  @override
  final Iterable<Type> types = const [MenuItemsV1List200Response, _$MenuItemsV1List200Response];

  @override
  final String wireName = r'MenuItemsV1List200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MenuItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'menuItems';
    yield serializers.serialize(
      object.menuItems,
      specifiedType: const FullType(BuiltList, [FullType(MenuItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MenuItemsV1List200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MenuItemsV1List200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'menuItems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MenuItem)]),
          ) as BuiltList<MenuItem>;
          result.menuItems.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MenuItemsV1List200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MenuItemsV1List200ResponseBuilder();
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

