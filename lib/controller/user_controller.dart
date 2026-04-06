import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/helper/firebase_auth_helper.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

final StreamProvider<User?> firebaseAuthStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final Provider<bool> isAuthenticatedProvider = Provider.autoDispose<bool>((ref) {
  final authState = ref.watch(firebaseAuthStateChangesProvider);
  return authState.value != null;
});

@riverpod
final class UserNotifier extends _$UserNotifier {
  @override
  Future<DottoUser> build() async {
    final authState = ref.watch(firebaseAuthStateChangesProvider);
    final firebaseUser = authState.value;
    if (firebaseUser != null) {
      debugPrint('FCM Token: ${await FirebaseMessaging.instance.getToken()}');
      await _saveFCMToken(firebaseUser);
    }
    return _syncUser(firebaseUser);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await _saveFCMToken(firebaseUser);
      }
      return _syncUser(firebaseUser);
    });
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = await FirebaseAuthHelper.signIn();
      await _saveFCMToken(firebaseUser);
      return _syncUser(firebaseUser);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuthHelper.signOut();
      return _syncUser(null);
    });
  }

  Future<void> setGrade(Grade? grade) async {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(grade: grade));
      await _upsertCurrentUser(current.copyWith(grade: grade));
    }
  }

  Future<void> setCourse(AcademicArea? course) async {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(course: course));
      await _upsertCurrentUser(current.copyWith(course: course));
    }
  }

  Future<void> setClass(AcademicClass? class_) async {
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

  Future<DottoUser> _syncUser(User? firebaseUser) async {
    const defaultUser = DottoUser(id: '', name: '', email: '', avatarUrl: '', grade: null, course: null, class_: null);
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
      try {
        return ref.read(userRepositoryProvider).upsertUser(firebaseUser: firebaseUser, user: user);
      } on Exception catch (e) {
        debugPrint('Error during upserting user: $e');
        return user;
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
    await ref.read(fcmTokenRepositoryProvider).upsertToken(token: fcmToken);
  }
}
