//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_service_syllabus.g.dart';

/// SubjectServiceSyllabus
///
/// Properties:
/// * [id] - 教務システムのシラバスID
/// * [name] - 授業名
/// * [enName] - 授業名 (en)
/// * [grades] - 配当年次
/// * [credit] - 単位数
/// * [facultyNames] - 担当教員名
/// * [practicalHomeFacultyCategory] - 実務家教員区分
/// * [multiplePersonTeachingForm] - 複数人担当形式
/// * [teachingForm] - 授業形態
/// * [summary] - 授業の概要
/// * [learningOutcomes] - 授業の到達目標
/// * [assignments] - 提出課題等
/// * [evaluationMethod] - 成績の評価方法・基準
/// * [textbooks] - テキスト
/// * [referenceBooks] - 参考書
/// * [prerequisites] - 履修条件
/// * [preLearning] - 事前学習
/// * [postLearning] - 事後学習
/// * [notes] - 履修上の留意点
/// * [keywords] - キーワード
/// * [targetCourses] - 対象コース・領域
/// * [targetAreas] - 対象領域
/// * [classifications] - 科目群・科目区分
/// * [teachingLanguage] - 教授言語
/// * [contentsAndSchedule] - 授業内容とスケジュール
/// * [teachingAndExamForm] - 授業・試験の形式
/// * [dspoSubject] - DSOP対象科目
@BuiltValue()
abstract class SubjectServiceSyllabus implements Built<SubjectServiceSyllabus, SubjectServiceSyllabusBuilder> {
  /// 教務システムのシラバスID
  @BuiltValueField(wireName: r'id')
  String get id;

  /// 授業名
  @BuiltValueField(wireName: r'name')
  String get name;

  /// 授業名 (en)
  @BuiltValueField(wireName: r'enName')
  String get enName;

  /// 配当年次
  @BuiltValueField(wireName: r'grades')
  String get grades;

  /// 単位数
  @BuiltValueField(wireName: r'credit')
  int get credit;

  /// 担当教員名
  @BuiltValueField(wireName: r'facultyNames')
  String get facultyNames;

  /// 実務家教員区分
  @BuiltValueField(wireName: r'practicalHomeFacultyCategory')
  String get practicalHomeFacultyCategory;

  /// 複数人担当形式
  @BuiltValueField(wireName: r'multiplePersonTeachingForm')
  String get multiplePersonTeachingForm;

  /// 授業形態
  @BuiltValueField(wireName: r'teachingForm')
  String get teachingForm;

  /// 授業の概要
  @BuiltValueField(wireName: r'summary')
  String get summary;

  /// 授業の到達目標
  @BuiltValueField(wireName: r'learningOutcomes')
  String get learningOutcomes;

  /// 提出課題等
  @BuiltValueField(wireName: r'assignments')
  String get assignments;

  /// 成績の評価方法・基準
  @BuiltValueField(wireName: r'evaluationMethod')
  String get evaluationMethod;

  /// テキスト
  @BuiltValueField(wireName: r'textbooks')
  String get textbooks;

  /// 参考書
  @BuiltValueField(wireName: r'referenceBooks')
  String get referenceBooks;

  /// 履修条件
  @BuiltValueField(wireName: r'prerequisites')
  String get prerequisites;

  /// 事前学習
  @BuiltValueField(wireName: r'preLearning')
  String get preLearning;

  /// 事後学習
  @BuiltValueField(wireName: r'postLearning')
  String get postLearning;

  /// 履修上の留意点
  @BuiltValueField(wireName: r'notes')
  String get notes;

  /// キーワード
  @BuiltValueField(wireName: r'keywords')
  String get keywords;

  /// 対象コース・領域
  @BuiltValueField(wireName: r'targetCourses')
  String get targetCourses;

  /// 対象領域
  @BuiltValueField(wireName: r'targetAreas')
  String get targetAreas;

  /// 科目群・科目区分
  @BuiltValueField(wireName: r'classifications')
  String get classifications;

  /// 教授言語
  @BuiltValueField(wireName: r'teachingLanguage')
  String get teachingLanguage;

  /// 授業内容とスケジュール
  @BuiltValueField(wireName: r'contentsAndSchedule')
  String get contentsAndSchedule;

  /// 授業・試験の形式
  @BuiltValueField(wireName: r'teachingAndExamForm')
  String get teachingAndExamForm;

  /// DSOP対象科目
  @BuiltValueField(wireName: r'dspoSubject')
  String get dspoSubject;

  SubjectServiceSyllabus._();

  factory SubjectServiceSyllabus([void updates(SubjectServiceSyllabusBuilder b)]) = _$SubjectServiceSyllabus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SubjectServiceSyllabusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectServiceSyllabus> get serializer => _$SubjectServiceSyllabusSerializer();
}

class _$SubjectServiceSyllabusSerializer implements PrimitiveSerializer<SubjectServiceSyllabus> {
  @override
  final Iterable<Type> types = const [SubjectServiceSyllabus, _$SubjectServiceSyllabus];

  @override
  final String wireName = r'SubjectServiceSyllabus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectServiceSyllabus object, {
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
    yield r'enName';
    yield serializers.serialize(
      object.enName,
      specifiedType: const FullType(String),
    );
    yield r'grades';
    yield serializers.serialize(
      object.grades,
      specifiedType: const FullType(String),
    );
    yield r'credit';
    yield serializers.serialize(
      object.credit,
      specifiedType: const FullType(int),
    );
    yield r'facultyNames';
    yield serializers.serialize(
      object.facultyNames,
      specifiedType: const FullType(String),
    );
    yield r'practicalHomeFacultyCategory';
    yield serializers.serialize(
      object.practicalHomeFacultyCategory,
      specifiedType: const FullType(String),
    );
    yield r'multiplePersonTeachingForm';
    yield serializers.serialize(
      object.multiplePersonTeachingForm,
      specifiedType: const FullType(String),
    );
    yield r'teachingForm';
    yield serializers.serialize(
      object.teachingForm,
      specifiedType: const FullType(String),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
    yield r'learningOutcomes';
    yield serializers.serialize(
      object.learningOutcomes,
      specifiedType: const FullType(String),
    );
    yield r'assignments';
    yield serializers.serialize(
      object.assignments,
      specifiedType: const FullType(String),
    );
    yield r'evaluationMethod';
    yield serializers.serialize(
      object.evaluationMethod,
      specifiedType: const FullType(String),
    );
    yield r'textbooks';
    yield serializers.serialize(
      object.textbooks,
      specifiedType: const FullType(String),
    );
    yield r'referenceBooks';
    yield serializers.serialize(
      object.referenceBooks,
      specifiedType: const FullType(String),
    );
    yield r'prerequisites';
    yield serializers.serialize(
      object.prerequisites,
      specifiedType: const FullType(String),
    );
    yield r'preLearning';
    yield serializers.serialize(
      object.preLearning,
      specifiedType: const FullType(String),
    );
    yield r'postLearning';
    yield serializers.serialize(
      object.postLearning,
      specifiedType: const FullType(String),
    );
    yield r'notes';
    yield serializers.serialize(
      object.notes,
      specifiedType: const FullType(String),
    );
    yield r'keywords';
    yield serializers.serialize(
      object.keywords,
      specifiedType: const FullType(String),
    );
    yield r'targetCourses';
    yield serializers.serialize(
      object.targetCourses,
      specifiedType: const FullType(String),
    );
    yield r'targetAreas';
    yield serializers.serialize(
      object.targetAreas,
      specifiedType: const FullType(String),
    );
    yield r'classifications';
    yield serializers.serialize(
      object.classifications,
      specifiedType: const FullType(String),
    );
    yield r'teachingLanguage';
    yield serializers.serialize(
      object.teachingLanguage,
      specifiedType: const FullType(String),
    );
    yield r'contentsAndSchedule';
    yield serializers.serialize(
      object.contentsAndSchedule,
      specifiedType: const FullType(String),
    );
    yield r'teachingAndExamForm';
    yield serializers.serialize(
      object.teachingAndExamForm,
      specifiedType: const FullType(String),
    );
    yield r'dspoSubject';
    yield serializers.serialize(
      object.dspoSubject,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectServiceSyllabus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectServiceSyllabusBuilder result,
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
        case r'enName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.enName = valueDes;
          break;
        case r'grades':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.grades = valueDes;
          break;
        case r'credit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.credit = valueDes;
          break;
        case r'facultyNames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.facultyNames = valueDes;
          break;
        case r'practicalHomeFacultyCategory':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.practicalHomeFacultyCategory = valueDes;
          break;
        case r'multiplePersonTeachingForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.multiplePersonTeachingForm = valueDes;
          break;
        case r'teachingForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.teachingForm = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        case r'learningOutcomes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.learningOutcomes = valueDes;
          break;
        case r'assignments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assignments = valueDes;
          break;
        case r'evaluationMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evaluationMethod = valueDes;
          break;
        case r'textbooks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.textbooks = valueDes;
          break;
        case r'referenceBooks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.referenceBooks = valueDes;
          break;
        case r'prerequisites':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.prerequisites = valueDes;
          break;
        case r'preLearning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.preLearning = valueDes;
          break;
        case r'postLearning':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.postLearning = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notes = valueDes;
          break;
        case r'keywords':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.keywords = valueDes;
          break;
        case r'targetCourses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetCourses = valueDes;
          break;
        case r'targetAreas':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetAreas = valueDes;
          break;
        case r'classifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.classifications = valueDes;
          break;
        case r'teachingLanguage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.teachingLanguage = valueDes;
          break;
        case r'contentsAndSchedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentsAndSchedule = valueDes;
          break;
        case r'teachingAndExamForm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.teachingAndExamForm = valueDes;
          break;
        case r'dspoSubject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dspoSubject = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SubjectServiceSyllabus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectServiceSyllabusBuilder();
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

