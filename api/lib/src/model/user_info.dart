//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_course.dart';
import 'package:openapi/src/model/dotto_foundation_v1_class.dart';
import 'package:openapi/src/model/dotto_foundation_v1_grade.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_info.g.dart';

/// UserInfo
///
/// Properties:
/// * [grade] 
/// * [course] 
/// * [class_] 
@BuiltValue()
abstract class UserInfo implements Built<UserInfo, UserInfoBuilder> {
  @BuiltValueField(wireName: r'grade')
  DottoFoundationV1Grade? get grade;
  // enum gradeEnum {  B1,  B2,  B3,  B4,  M1,  M2,  D1,  D2,  D3,  };

  @BuiltValueField(wireName: r'course')
  DottoFoundationV1Course? get course;
  // enum courseEnum {  InformationSystem,  InformationDesign,  AdvancedICT,  ComplexSystem,  IntelligentSystem,  };

  @BuiltValueField(wireName: r'class')
  DottoFoundationV1Class? get class_;
  // enum class_Enum {  A,  B,  C,  D,  E,  F,  G,  H,  I,  J,  K,  L,  };

  UserInfo._();

  factory UserInfo([void updates(UserInfoBuilder b)]) = _$UserInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserInfo> get serializer => _$UserInfoSerializer();
}

class _$UserInfoSerializer implements PrimitiveSerializer<UserInfo> {
  @override
  final Iterable<Type> types = const [UserInfo, _$UserInfo];

  @override
  final String wireName = r'UserInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.grade != null) {
      yield r'grade';
      yield serializers.serialize(
        object.grade,
        specifiedType: const FullType(DottoFoundationV1Grade),
      );
    }
    if (object.course != null) {
      yield r'course';
      yield serializers.serialize(
        object.course,
        specifiedType: const FullType(DottoFoundationV1Course),
      );
    }
    if (object.class_ != null) {
      yield r'class';
      yield serializers.serialize(
        object.class_,
        specifiedType: const FullType(DottoFoundationV1Class),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UserInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'grade':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Grade),
          ) as DottoFoundationV1Grade;
          result.grade = valueDes;
          break;
        case r'course':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Course),
          ) as DottoFoundationV1Course;
          result.course = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DottoFoundationV1Class),
          ) as DottoFoundationV1Class;
          result.class_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserInfoBuilder();
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

