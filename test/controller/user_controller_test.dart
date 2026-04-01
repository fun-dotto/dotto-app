import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/user_preference_keys.dart';
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
  FakeFirebaseAuthPlatform({super.appInstance, UserPlatform? currentUser}) : _currentUser = currentUser;

  UserPlatform? _currentUser;

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) {
    return FakeFirebaseAuthPlatform(appInstance: app, currentUser: _currentUser);
  }

  @override
  FirebaseAuthPlatform setInitialValues({PigeonUserDetails? currentUser, String? languageCode}) {
    return this;
  }

  @override
  UserPlatform? get currentUser => _currentUser;

  @override
  set currentUser(UserPlatform? userPlatform) {
    _currentUser = userPlatform;
  }

  @override
  Stream<UserPlatform?> authStateChanges() => Stream<UserPlatform?>.value(_currentUser);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream<UserPlatform?>.value(_currentUser);

  @override
  Stream<UserPlatform?> userChanges() => Stream<UserPlatform?>.value(_currentUser);

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
        overrides: [firebaseAuthStateChangesProvider.overrideWith((ref) => Stream<User?>.value(null))],
      );
    }

    test('未認証時は空の DottoUser を返す', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final user = await container.read(userProvider.future);

      expect(user.id, isEmpty);
      expect(user.name, isEmpty);
      expect(user.email, isEmpty);
      expect(user.avatarUrl, isEmpty);
      expect(user.grade, isNull);
      expect(user.course, isNull);
      expect(user.class_, isNull);
    });

    test('setGrade と setCourse と setClass は現在の state だけ更新する', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      await container.read(userProvider.future);

      final notifier = container.read(userProvider.notifier);
      await notifier.setGrade(Grade.b2);
      await notifier.setCourse(AcademicArea.informationDesignCourse);
      await notifier.setClass(AcademicClass.c);

      final user = container.read(userProvider).requireValue;

      expect(user.grade, Grade.b2);
      expect(user.course, AcademicArea.informationDesignCourse);
      expect(user.class_, AcademicClass.c);
    });

    test('旧 UserPreference に値が残っていても復元しない', () async {
      SharedPreferences.setMockInitialValues({
        UserPreferenceKeys.grade.key: 'b4',
        UserPreferenceKeys.course.key: 'complexCourse',
        UserPreferenceKeys.class_.key: 'f',
      });

      final container = createContainer();
      addTearDown(container.dispose);

      final user = await container.read(userProvider.future);

      expect(user.grade, isNull);
      expect(user.course, isNull);
      expect(user.class_, isNull);
    });
  });

  group('isAuthenticatedProvider', () {
    test('認証ユーザーがいないと false を返す', () async {
      final container = ProviderContainer(
        overrides: [firebaseAuthStateChangesProvider.overrideWith((ref) => Stream<User?>.value(null))],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(firebaseAuthStateChangesProvider, (_, _) {}, fireImmediately: true);
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(isAuthenticatedProvider), isFalse);
    });

    test('認証ユーザーがいると true を返す', () async {
      final mockUser = MockFirebaseUser();
      final container = ProviderContainer(
        overrides: [firebaseAuthStateChangesProvider.overrideWith((ref) => Stream<User?>.value(mockUser))],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(firebaseAuthStateChangesProvider, (_, _) {}, fireImmediately: true);
      addTearDown(subscription.close);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(isAuthenticatedProvider), isTrue);
    });
  });
}
