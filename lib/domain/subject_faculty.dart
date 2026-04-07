import 'package:dotto/domain/faculty.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_faculty.freezed.dart';

@freezed
abstract class SubjectFaculty with _$SubjectFaculty {
  const factory SubjectFaculty({
    required Faculty faculty,
    required bool isPrimary,
  }) = _SubjectFaculty;
}
