import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
final class UserNotifier extends _$UserNotifier {
  @override
  User? build() {
    return FirebaseAuth.instance.currentUser;
  }

  User? get user => state;

  set user(User? user) {
    state = user;
  }

  void logout() {
    state = null;
  }

  bool get isAuthenticated {
    return state != null;
  }
}
