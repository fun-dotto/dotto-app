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
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
final class UserNotifier extends _$UserNotifier {
  @override
  Future<DottoUser> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
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
        'informationSystem' => AcademicArea.informationSystemCourse,
        'informationDesign' => AcademicArea.informationDesignCourse,
        'complexSystem' => AcademicArea.complexCourse,
        'intelligentSystem' => AcademicArea.intelligenceSystemCourse,
        'advancedICT' => AcademicArea.advancedICTCourse,
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
      return DottoUser(id: '', name: '', email: '', avatarUrl: '', grade: grade, course: course, class_: class_);
    }
    return ref.read(userRepositoryProvider).getUser(user);
  }

  bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    if (!(await UserPreferenceRepository.getBool(UserPreferenceKeys.didSaveFCMToken) ?? false)) {
      await _saveFCMToken(user);
    }
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).getUser(user));
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    final user = await FirebaseAuthHelper.signIn();
    if (user == null) {
      return;
    }
    await _saveFCMToken(user);
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).getUser(user));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await FirebaseAuthHelper.signOut();
    state = const AsyncValue.data(
      DottoUser(id: '', name: '', email: '', avatarUrl: '', grade: null, course: null, class_: null),
    );
  }

  Future<void> _saveFCMToken(User user) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      return;
    }
    final db = FirebaseFirestore.instance;
    final tokenRef = db.collection('fcm_token');
    final tokenQuery = tokenRef.where('uid', isEqualTo: user.uid).where('token', isEqualTo: fcmToken);
    final tokenQuerySnapshot = await tokenQuery.get();
    final tokenDocs = tokenQuerySnapshot.docs;
    if (tokenDocs.isEmpty) {
      await tokenRef.add({'uid': user.uid, 'token': fcmToken, 'last_updated': Timestamp.now()});
    }
    await UserPreferenceRepository.setBool(UserPreferenceKeys.didSaveFCMToken, value: true);
  }

  Future<void> setGrade(Grade? grade) async {
    final user = state.value?.copyWith(grade: grade);
    if (user == null) {
      return;
    }
    await UserPreferenceRepository.setString(UserPreferenceKeys.grade, grade?.name ?? '');
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).upsertUser(user));
  }

  Future<void> setCourse(AcademicArea? course) async {
    final user = state.value?.copyWith(course: course);
    if (user == null) {
      return;
    }
    await UserPreferenceRepository.setString(UserPreferenceKeys.course, course?.name ?? '');
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).upsertUser(user));
  }

  Future<void> setClass(AcademicClass? class_) async {
    final user = state.value?.copyWith(class_: class_);
    if (user == null) {
      return;
    }
    await UserPreferenceRepository.setString(UserPreferenceKeys.class_, class_?.name ?? '');
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).upsertUser(user));
  }
}
