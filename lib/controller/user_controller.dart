import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/firebase_auth_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
final class UserNotifier extends _$UserNotifier {
  @override
  Future<DottoUser> build() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final didSaveFCMToken = await UserPreferenceRepository.getBool(UserPreferenceKeys.didSaveFCMToken);
    if (firebaseUser != null && didSaveFCMToken == false) {
      await _saveFCMToken(firebaseUser);
    }
    return _syncUser();
  }

  bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final didSaveFCMToken = await UserPreferenceRepository.getBool(UserPreferenceKeys.didSaveFCMToken);
      if (firebaseUser != null && didSaveFCMToken == false) {
        await _saveFCMToken(firebaseUser);
      }
      return _syncUser();
    });
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = await FirebaseAuthHelper.signIn();
      await _saveFCMToken(firebaseUser);
      return _syncUser();
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuthHelper.signOut();
      return _syncUser();
    });
  }

  Future<void> setGrade(Grade? grade) async {
    await UserPreferenceRepository.setString(UserPreferenceKeys.grade, grade?.name ?? '');
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(grade: grade));
      await _upsertCurrentUser(current.copyWith(grade: grade));
    }
  }

  Future<void> setCourse(AcademicArea? course) async {
    await UserPreferenceRepository.setString(UserPreferenceKeys.course, course?.name ?? '');
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(course: course));
      await _upsertCurrentUser(current.copyWith(course: course));
    }
  }

  Future<void> setClass(AcademicClass? class_) async {
    await UserPreferenceRepository.setString(UserPreferenceKeys.class_, class_?.name ?? '');
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(class_: class_));
      await _upsertCurrentUser(current.copyWith(class_: class_));
    }
  }

  Future<void> _upsertCurrentUser(DottoUser user) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    try {
      await ref.read(userRepositoryProvider).upsertUser(firebaseUser: firebaseUser, user: user);
    } on Exception catch (e) {
      debugPrint('Error during upserting user: $e');
    }
  }

  Future<DottoUser> _syncUser() async {
    final grade = switch (await UserPreferenceRepository.getString(UserPreferenceKeys.grade)) {
      'b1' => Grade.b1,
      'b2' => Grade.b2,
      'b3' => Grade.b3,
      'b4' => Grade.b4,
      'm1' => Grade.m1,
      'm2' => Grade.m2,
      'd1' => Grade.d1,
      'd2' => Grade.d2,
      'd3' => Grade.d3,
      _ => null,
    };
    final course = switch (await UserPreferenceRepository.getString(UserPreferenceKeys.course)) {
      'informationSystemCourse' => AcademicArea.informationSystemCourse,
      'informationDesignCourse' => AcademicArea.informationDesignCourse,
      'complexCourse' => AcademicArea.complexCourse,
      'intelligenceSystemCourse' => AcademicArea.intelligenceSystemCourse,
      'advancedICTCourse' => AcademicArea.advancedICTCourse,
      _ => null,
    };
    final class_ = switch (await UserPreferenceRepository.getString(UserPreferenceKeys.class_)) {
      'a' => AcademicClass.a,
      'b' => AcademicClass.b,
      'c' => AcademicClass.c,
      'd' => AcademicClass.d,
      'e' => AcademicClass.e,
      'f' => AcademicClass.f,
      'g' => AcademicClass.g,
      'h' => AcademicClass.h,
      'i' => AcademicClass.i,
      'j' => AcademicClass.j,
      'k' => AcademicClass.k,
      'l' => AcademicClass.l,
      _ => null,
    };
    final defaultUser = DottoUser(
      id: '',
      name: '',
      email: '',
      avatarUrl: '',
      grade: grade,
      course: course,
      class_: class_,
    );
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      return defaultUser;
    }
    try {
      final user =
          await ref.read(userRepositoryProvider).getUser(firebaseUser: firebaseUser) ??
          defaultUser.copyWith(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            avatarUrl: firebaseUser.photoURL ?? '',
          );
      final updatedUser = user.copyWith(
        grade: user.grade ?? grade,
        course: user.course ?? course,
        class_: user.class_ ?? class_,
      );
      try {
        return ref.read(userRepositoryProvider).upsertUser(firebaseUser: firebaseUser, user: updatedUser);
      } on Exception catch (e) {
        debugPrint('Error during upserting user: $e');
        return updatedUser;
      }
    } on Exception catch (e) {
      debugPrint('Error during getting user: $e');
      return defaultUser;
    }
  }

  Future<void> _saveFCMToken(User firebaseUser) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      return;
    }
    final db = FirebaseFirestore.instance;
    final tokenRef = db.collection('fcm_token');
    final tokenQuery = tokenRef.where('uid', isEqualTo: firebaseUser.uid).where('token', isEqualTo: fcmToken);
    final tokenQuerySnapshot = await tokenQuery.get();
    final tokenDocs = tokenQuerySnapshot.docs;
    if (tokenDocs.isEmpty) {
      await tokenRef.add({'uid': firebaseUser.uid, 'token': fcmToken, 'last_updated': Timestamp.now()});
    }
    await UserPreferenceRepository.setBool(UserPreferenceKeys.didSaveFCMToken, value: true);
  }
}
