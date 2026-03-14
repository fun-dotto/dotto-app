import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotto/domain/dotto_user.dart';
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
  Future<DottoUser?> build() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return ref.read(userRepositoryProvider).getUser(user);
  }

  DottoUser? get user => state.value;

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
    state = const AsyncValue.data(null);
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
}
