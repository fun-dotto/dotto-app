import 'package:dotto/domain/notification_alert_status.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';

NotificationSettings _settings({
  required AuthorizationStatus authorizationStatus,
  AppleNotificationSetting alert = AppleNotificationSetting.enabled,
}) {
  return NotificationSettings(
    alert: alert,
    announcement: AppleNotificationSetting.disabled,
    authorizationStatus: authorizationStatus,
    badge: AppleNotificationSetting.disabled,
    carPlay: AppleNotificationSetting.disabled,
    lockScreen: AppleNotificationSetting.disabled,
    notificationCenter: AppleNotificationSetting.disabled,
    showPreviews: AppleShowPreviewSetting.never,
    timeSensitive: AppleNotificationSetting.disabled,
    criticalAlert: AppleNotificationSetting.disabled,
    sound: AppleNotificationSetting.disabled,
    providesAppNotificationSettings: AppleNotificationSetting.disabled,
  );
}

void main() {
  group('NotificationAlertStatus.fromSettings', () {
    test('notDetermined を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(authorizationStatus: AuthorizationStatus.notDetermined),
      );
      expect(result, NotificationAlertStatus.notDetermined);
    });

    test('denied を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(authorizationStatus: AuthorizationStatus.denied),
      );
      expect(result, NotificationAlertStatus.denied);
    });

    test('provisional を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(authorizationStatus: AuthorizationStatus.provisional),
      );
      expect(result, NotificationAlertStatus.provisional);
    });

    test('authorized かつ alert が enabled なら enabled を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(
          authorizationStatus: AuthorizationStatus.authorized,
          alert: AppleNotificationSetting.enabled,
        ),
      );
      expect(result, NotificationAlertStatus.enabled);
    });

    test('authorized でも alert が disabled なら alertDisabled を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(
          authorizationStatus: AuthorizationStatus.authorized,
          alert: AppleNotificationSetting.disabled,
        ),
      );
      expect(result, NotificationAlertStatus.alertDisabled);
    });

    test('authorized かつ alert が notSupported なら enabled を返す', () {
      final result = NotificationAlertStatus.fromSettings(
        _settings(
          authorizationStatus: AuthorizationStatus.authorized,
          alert: AppleNotificationSetting.notSupported,
        ),
      );
      expect(result, NotificationAlertStatus.enabled);
    });
  });
}
