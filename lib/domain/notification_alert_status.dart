import 'package:firebase_messaging/firebase_messaging.dart';

enum NotificationAlertStatus {
  enabled,
  provisional,
  alertDisabled,
  denied,
  notDetermined;

  bool get isProminentEnabled => this == NotificationAlertStatus.enabled;

  bool get shouldPromptUser => switch (this) {
    NotificationAlertStatus.denied ||
    NotificationAlertStatus.provisional ||
    NotificationAlertStatus.alertDisabled => true,
    NotificationAlertStatus.enabled ||
    NotificationAlertStatus.notDetermined => false,
  };

  String get label => switch (this) {
    NotificationAlertStatus.enabled => '有効',
    NotificationAlertStatus.provisional => '静かな配信',
    NotificationAlertStatus.alertDisabled => 'バナー無効',
    NotificationAlertStatus.denied => '拒否',
    NotificationAlertStatus.notDetermined => '未設定',
  };

  static NotificationAlertStatus fromSettings(NotificationSettings settings) {
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.notDetermined:
        return NotificationAlertStatus.notDetermined;
      case AuthorizationStatus.denied:
        return NotificationAlertStatus.denied;
      case AuthorizationStatus.provisional:
        return NotificationAlertStatus.provisional;
      case AuthorizationStatus.authorized:
        return settings.alert == AppleNotificationSetting.disabled
            ? NotificationAlertStatus.alertDisabled
            : NotificationAlertStatus.enabled;
    }
  }
}
