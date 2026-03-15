import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/grade.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dotto_user.freezed.dart';

@freezed
abstract class DottoUser with _$DottoUser {
  const factory DottoUser({
    required String id,
    required String name,
    required String email,
    required String avatarUrl,
    required Grade? grade,
    required AcademicArea? course,
    required AcademicClass? class_,
  }) = _DottoUser;
}
