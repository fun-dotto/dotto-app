import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto/domain/grade.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

final userRepositoryProvider = Provider<UserRepository>(UserRepositoryImpl.new);

abstract class UserRepository {
  Future<DottoUser> getUser(User firebaseUser);

  Future<DottoUser> upsertUser(DottoUser user);
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

  @override
  Future<DottoUser> upsertUser(DottoUser user) async {
    try {
      final api = ref.read(apiClientProvider).getUsersApi();
      final userInfo = UserInfo(
        (b) => b
          ..grade = switch (user.grade) {
            Grade.b1 => DottoFoundationV1Grade.b1,
            Grade.b2 => DottoFoundationV1Grade.b2,
            Grade.b3 => DottoFoundationV1Grade.b3,
            Grade.b4 => DottoFoundationV1Grade.b4,
            Grade.m1 => DottoFoundationV1Grade.m1,
            Grade.m2 => DottoFoundationV1Grade.m2,
            Grade.d1 => DottoFoundationV1Grade.d1,
            Grade.d2 => DottoFoundationV1Grade.d2,
            Grade.d3 => DottoFoundationV1Grade.d3,
            null => null,
          }
          ..course = switch (user.course) {
            AcademicArea.informationSystemCourse => DottoFoundationV1Course.informationSystem,
            AcademicArea.informationDesignCourse => DottoFoundationV1Course.informationDesign,
            AcademicArea.complexCourse => DottoFoundationV1Course.complexSystem,
            AcademicArea.intelligenceSystemCourse => DottoFoundationV1Course.intelligentSystem,
            AcademicArea.advancedICTCourse => DottoFoundationV1Course.advancedICT,
            _ => null,
          }
          ..class_ = switch (user.class_) {
            AcademicClass.a => DottoFoundationV1Class.A,
            AcademicClass.b => DottoFoundationV1Class.B,
            AcademicClass.c => DottoFoundationV1Class.C,
            AcademicClass.d => DottoFoundationV1Class.D,
            AcademicClass.e => DottoFoundationV1Class.E,
            AcademicClass.f => DottoFoundationV1Class.F,
            AcademicClass.g => DottoFoundationV1Class.G,
            AcademicClass.h => DottoFoundationV1Class.H,
            AcademicClass.i => DottoFoundationV1Class.I,
            AcademicClass.j => DottoFoundationV1Class.J,
            AcademicClass.k => DottoFoundationV1Class.K,
            AcademicClass.l => DottoFoundationV1Class.L,
            null => null,
          },
      );
      final response = await api.usersV1Upsert(userInfo: userInfo);
      if (response.statusCode != 200) {
        throw Exception('Failed to upsert user');
      }
      final data = response.data;
      if (data == null) {
        throw Exception('Failed to upsert user');
      }
      return user;
    } on Exception catch (e) {
      debugPrint('Error during upserting user: $e');
      throw Exception('Failed to upsert user');
    }
  }
}
