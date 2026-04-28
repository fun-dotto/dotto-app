import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/dotto_user.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/helper/firebase_auth_helper.dart';
import 'package:dotto/helper/firebase_auth_provider.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

final Provider<bool> isAuthenticatedProvider = Provider.autoDispose<bool>((
  ref,
) {
  final authState = ref.watch(firebaseAuthStateChangesProvider);
  return authState.value != null;
});

@riverpod
final class UserNotifier extends _$UserNotifier {
  @override
  Future<DottoUser> build() async {
    final userRepository = ref.read(userRepositoryProvider);
    final authState = ref.watch(firebaseAuthStateChangesProvider);
    final firebaseUser = authState.value;
    return _syncUser(firebaseUser, userRepository);
  }

  Future<void> refresh() async {
    final userRepository = ref.read(userRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      return _syncUser(firebaseUser, userRepository);
    });
  }

  Future<void> signIn() async {
    final userRepository = ref.read(userRepositoryProvider);
    final logger = ref.read(loggerProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final firebaseUser = await FirebaseAuthHelper.signIn();
      await logger.logLogin();
      return _syncUser(firebaseUser, userRepository);
    });
  }

  Future<void> signOut() async {
    final userRepository = ref.read(userRepositoryProvider);
    final logger = ref.read(loggerProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseAuthHelper.signOut();
      await logger.logLogout();
      return _syncUser(null, userRepository);
    });
  }

  Future<void> setGrade(Grade? grade) async {
    final current = state.value;
    if (current != null) {
      final userRepository = ref.read(userRepositoryProvider);
      state = AsyncValue.data(current.copyWith(grade: grade));
      await _upsertCurrentUser(current.copyWith(grade: grade), userRepository);
    }
  }

  Future<void> setCourse(AcademicArea? course) async {
    final current = state.value;
    if (current != null) {
      final userRepository = ref.read(userRepositoryProvider);
      state = AsyncValue.data(current.copyWith(course: course));
      await _upsertCurrentUser(
        current.copyWith(course: course),
        userRepository,
      );
    }
  }

  Future<void> setClass(AcademicClass? class_) async {
    final current = state.value;
    if (current != null) {
      final userRepository = ref.read(userRepositoryProvider);
      state = AsyncValue.data(current.copyWith(class_: class_));
      await _upsertCurrentUser(
        current.copyWith(class_: class_),
        userRepository,
      );
    }
  }

  Future<void> _upsertCurrentUser(
    DottoUser user,
    UserRepository userRepository,
  ) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    try {
      await userRepository.upsertUser(firebaseUser: firebaseUser, user: user);
    } on Exception catch (e) {
      debugPrint('Error during upserting user: $e');
    }
  }

  Future<DottoUser> _syncUser(
    User? firebaseUser,
    UserRepository userRepository,
  ) async {
    const defaultUser = DottoUser(
      id: '',
      name: '',
      email: '',
      avatarUrl: '',
      grade: null,
      course: null,
      class_: null,
    );
    if (firebaseUser == null) {
      return defaultUser;
    }
    try {
      final user =
          await userRepository.getUser(firebaseUser: firebaseUser) ??
          defaultUser.copyWith(
            id: firebaseUser.uid,
            name: firebaseUser.displayName ?? '',
            email: firebaseUser.email ?? '',
            avatarUrl: firebaseUser.photoURL ?? '',
          );
      try {
        return await userRepository.upsertUser(
          firebaseUser: firebaseUser,
          user: user,
        );
      } on Exception catch (e) {
        debugPrint('Error during upserting user: $e');
        return user;
      }
    } on Exception catch (e) {
      debugPrint('Error during getting user: $e');
      return defaultUser;
    }
  }

}
