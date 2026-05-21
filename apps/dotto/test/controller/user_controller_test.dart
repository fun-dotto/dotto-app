import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/helper/firebase_auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class MockFirebaseUser extends Mock implements User {}

final class FakeFirebaseAuthPlatform extends FirebaseAuthPlatform {
  FakeFirebaseAuthPlatform({super.appInstance, this._currentUser});

  UserPlatform? _currentUser;

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) {
    return FakeFirebaseAuthPlatform(
      appInstance: app,
      currentUser: _currentUser,
    );
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    InternalUserDetails? currentUser,
    String? languageCode,
  }) {
    return this;
  }

  @override
  UserPlatform? get currentUser => _currentUser;

  @override
  set currentUser(UserPlatform? userPlatform) {
    _currentUser = userPlatform;
  }

  @override
  Stream<UserPlatform?> authStateChanges() =>
      Stream<UserPlatform?>.value(_currentUser);

  @override
  Stream<UserPlatform?> idTokenChanges() =>
      Stream<UserPlatform?>.value(_currentUser);

  @override
  Stream<UserPlatform?> userChanges() =>
      Stream<UserPlatform?>.value(_currentUser);

  @override
  void sendAuthChangesEvent(String appName, UserPlatform? userPlatform) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FirebaseAuthPlatform.instance = FakeFirebaseAuthPlatform();
  });

  group('UserNotifier', () {
    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          firebaseAuthStateChangesProvider.overrideWith(
            (ref) => Stream<User?>.value(null),
          ),
        ],
      );
    }

    test('未認証時は null を返す', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final user = await container.read(userProvider.future);

      expect(user, isNull);
    });

    test('未認証時の setGrade/setCourse/setClass は state を更新しない', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(userProvider.future);

      final notifier = container.read(userProvider.notifier);
      await notifier.setGrade(Grade.b2);
      await notifier.setCourse(AcademicArea.informationDesignCourse);
      await notifier.setClass(AcademicClass.c);

      expect(container.read(userProvider).requireValue, isNull);
    });
  });

  group('isAuthenticatedProvider', () {
    test('認証ユーザーがいないと false を返す', () async {
      final container = ProviderContainer(
        overrides: [
          firebaseAuthStateChangesProvider.overrideWith(
            (ref) => Stream<User?>.value(null),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        firebaseAuthStateChangesProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(isAuthenticatedProvider), isFalse);
    });

    test('認証ユーザーがいると true を返す', () async {
      final mockUser = MockFirebaseUser();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthStateChangesProvider.overrideWith(
            (ref) => Stream<User?>.value(mockUser),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        firebaseAuthStateChangesProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(isAuthenticatedProvider), isTrue);
    });
  });
}
