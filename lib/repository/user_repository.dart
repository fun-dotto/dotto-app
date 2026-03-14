import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto/domain/grade.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl(ref));

abstract class UserRepository {
  Future<DottoUser> getUser(User firebaseUser);
}

final class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<DottoUser> getUser(User firebaseUser) async {
    try {
      final api = ref.read(apiClientProvider).getUsersApi();
      final response = await api.usersV1Detail();
      if (response.statusCode != 200) {
        throw Exception('Failed to get user');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to get user');
      }
      return DottoUser(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        avatarUrl: firebaseUser.photoURL ?? '',
        grade: switch (data.user.grade) {
          DottoFoundationV1Grade.b1 => Grade.b1,
          DottoFoundationV1Grade.b2 => Grade.b2,
          DottoFoundationV1Grade.b3 => Grade.b3,
          DottoFoundationV1Grade.b4 => Grade.b4,
          DottoFoundationV1Grade.m1 => Grade.m1,
          DottoFoundationV1Grade.m2 => Grade.m2,
          DottoFoundationV1Grade.d1 => Grade.d1,
          DottoFoundationV1Grade.d2 => Grade.d2,
          DottoFoundationV1Grade.d3 => Grade.d3,
          _ => null,
        },
        course: switch (data.user.course) {
          DottoFoundationV1Course.informationSystem => AcademicArea.informationSystemCourse,
          DottoFoundationV1Course.informationDesign => AcademicArea.informationDesignCourse,
          DottoFoundationV1Course.complexSystem => AcademicArea.complexCourse,
          DottoFoundationV1Course.intelligentSystem => AcademicArea.intelligenceSystemCourse,
          DottoFoundationV1Course.advancedICT => AcademicArea.advancedICTCourse,
          _ => null,
        },
        class_: switch (data.user.class_) {
          DottoFoundationV1Class.A => AcademicClass.a,
          DottoFoundationV1Class.B => AcademicClass.b,
          DottoFoundationV1Class.C => AcademicClass.c,
          DottoFoundationV1Class.D => AcademicClass.d,
          DottoFoundationV1Class.E => AcademicClass.e,
          DottoFoundationV1Class.F => AcademicClass.f,
          DottoFoundationV1Class.G => AcademicClass.g,
          DottoFoundationV1Class.H => AcademicClass.h,
          DottoFoundationV1Class.I => AcademicClass.i,
          DottoFoundationV1Class.J => AcademicClass.j,
          DottoFoundationV1Class.K => AcademicClass.k,
          DottoFoundationV1Class.L => AcademicClass.l,
          _ => null,
        },
      );
    } on Exception catch (e) {
      debugPrint('Error during getting user: $e');
      throw Exception('Failed to get user');
    }
  }
}
