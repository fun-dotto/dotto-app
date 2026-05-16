//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/size.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'price.g.dart';

/// Price
///
/// Properties:
/// * [size] 
/// * [price] 
@BuiltValue()
abstract class Price implements Built<Price, PriceBuilder> {
  @BuiltValueField(wireName: r'size')
  Size get size;
  // enum sizeEnum {  Small,  Medium,  Large,  };

  @BuiltValueField(wireName: r'price')
  int get price;

  Price._();

  factory Price([void updates(PriceBuilder b)]) = _$Price;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PriceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Price> get serializer => _$PriceSerializer();
}

class _$PriceSerializer implements PrimitiveSerializer<Price> {
  @override
  final Iterable<Type> types = const [Price, _$Price];

  @override
  final String wireName = r'Price';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Price object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'size';
    yield serializers.serialize(
      object.size,
      specifiedType: const FullType(Size),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Price object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PriceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Size),
          ) as Size;
          result.size = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.price = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Price deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PriceBuilder();
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

