//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/academic_service_faculty.dart';
import 'package:openapi/src/model/academic_service_subject_requirement.dart';
import 'package:openapi/src/model/academic_service_subject_target_class.dart';
import 'package:openapi/src/model/academic_service_syllabus.dart';
import 'package:openapi/src/model/announcement.dart';
import 'package:openapi/src/model/announcements_v1_list200_response.dart';
import 'package:openapi/src/model/course_registration.dart';
import 'package:openapi/src/model/course_registration_request.dart';
import 'package:openapi/src/model/course_registrations_v1_create201_response.dart';
import 'package:openapi/src/model/course_registrations_v1_list200_response.dart';
import 'package:openapi/src/model/dotto_foundation_v1_class.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course.dart';
import 'package:openapi/src/model/dotto_foundation_v1_course_semester.dart';
import 'package:openapi/src/model/dotto_foundation_v1_cultural_subject_category.dart';
import 'package:openapi/src/model/dotto_foundation_v1_day_of_week.dart';
import 'package:openapi/src/model/dotto_foundation_v1_floor.dart';
import 'package:openapi/src/model/dotto_foundation_v1_grade.dart';
import 'package:openapi/src/model/dotto_foundation_v1_period.dart';
import 'package:openapi/src/model/dotto_foundation_v1_subject_classification.dart';
import 'package:openapi/src/model/dotto_foundation_v1_subject_requirement_type.dart';
import 'package:openapi/src/model/dotto_foundation_v1_timetable_slot.dart';
import 'package:openapi/src/model/personal_calendar_item.dart';
import 'package:openapi/src/model/personal_calendar_items_v1_list200_response.dart';
import 'package:openapi/src/model/room.dart';
import 'package:openapi/src/model/subject_detail.dart';
import 'package:openapi/src/model/subject_faculty.dart';
import 'package:openapi/src/model/subject_summary.dart';
import 'package:openapi/src/model/subjects_v1_detail200_response.dart';
import 'package:openapi/src/model/subjects_v1_list200_response.dart';
import 'package:openapi/src/model/timetable_item.dart';
import 'package:openapi/src/model/timetable_items_v1_list200_response.dart';
import 'package:openapi/src/model/user_info.dart';
import 'package:openapi/src/model/users_v1_detail200_response.dart';

part 'serializers.g.dart';

@SerializersFor([
  AcademicServiceFaculty,
  AcademicServiceSubjectRequirement,
  AcademicServiceSubjectTargetClass,
  AcademicServiceSyllabus,
  Announcement,
  AnnouncementsV1List200Response,
  CourseRegistration,
  CourseRegistrationRequest,
  CourseRegistrationsV1Create201Response,
  CourseRegistrationsV1List200Response,
  DottoFoundationV1Class,
  DottoFoundationV1Course,
  DottoFoundationV1CourseSemester,
  DottoFoundationV1CulturalSubjectCategory,
  DottoFoundationV1DayOfWeek,
  DottoFoundationV1Floor,
  DottoFoundationV1Grade,
  DottoFoundationV1Period,
  DottoFoundationV1SubjectClassification,
  DottoFoundationV1SubjectRequirementType,
  DottoFoundationV1TimetableSlot,
  PersonalCalendarItem,
  PersonalCalendarItemsV1List200Response,
  Room,
  SubjectDetail,
  SubjectFaculty,
  SubjectSummary,
  SubjectsV1Detail200Response,
  SubjectsV1List200Response,
  TimetableItem,
  TimetableItemsV1List200Response,
  UserInfo,
  UsersV1Detail200Response,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Announcement)]),
        () => ListBuilder<Announcement>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1SubjectRequirementType)]),
        () => ListBuilder<DottoFoundationV1SubjectRequirementType>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1CourseSemester)]),
        () => ListBuilder<DottoFoundationV1CourseSemester>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DateTime)]),
        () => ListBuilder<DateTime>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1Class)]),
        () => ListBuilder<DottoFoundationV1Class>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1Grade)]),
        () => ListBuilder<DottoFoundationV1Grade>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1SubjectClassification)]),
        () => ListBuilder<DottoFoundationV1SubjectClassification>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1CulturalSubjectCategory)]),
        () => ListBuilder<DottoFoundationV1CulturalSubjectCategory>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DottoFoundationV1Course)]),
        () => ListBuilder<DottoFoundationV1Course>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
