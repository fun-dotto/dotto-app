//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/dotto_foundation_v1_class.dart';
import 'package:openapi/src/model/dotto_foundation_v1_grade.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'academic_service_subject_target_class.g.dart';

/// 対象学年・クラス
///
/// Properties:
/// * [grade] 
/// * [class_] - 修士課程・博士課程対象の場合はnull
@BuiltValue()
abstract class AcademicServiceSubjectTargetClass implements Built<AcademicServiceSubjectTargetClass, AcademicServiceSubjectTargetClassBuilder> {
  @BuiltValueField(wireName: r'grade')
  DottoFoundationV1Grade get grade;
  // enum gradeEnum {  B1,  B2,  B3,  B4,  M1,  M2,  D1,  D2,  D3,  };

  /// 修士課程・博士課程対象の場合はnull
  @BuiltValueField(wireName: r'class')
  DottoFoundationV1Class? get class_;
  // enum class_Enum {  A,  B,  C,  D,  E,  F,  G,  H,  I,  J,  K,  L,  };

  AcademicServiceSubjectTargetClass._();

  factory AcademicServiceSubjectTargetClass([void updates(AcademicServiceSubjectTargetClassBuilder b)]) = _$AcademicServiceSubjectTargetClass;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcademicServiceSubjectTargetClassBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AcademicServiceSubjectTargetClass> get serializer => _$AcademicServiceSubjectTargetClassSerializer();
}

class _$AcademicServiceSubjectTargetClassSerializer implements PrimitiveSerializer<AcademicServiceSubjectTargetClass> {
  @override
  final Iterable<Type> types = const [AcademicServiceSubjectTargetClass, _$AcademicServiceSubjectTargetClass];

  @override
  final String wireName = r'AcademicServiceSubjectTargetClass';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AcademicServiceSubjectTargetClass object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'grade';
    yield serializers.serialize(
      object.grade,
      specifiedType: const FullType(DottoFoundationV1Grade),
    );
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
    AcademicServiceSubjectTargetClass object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AcademicServiceSubjectTargetClassBuilder result,
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
  AcademicServiceSubjectTargetClass deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcademicServiceSubjectTargetClassBuilder();
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

