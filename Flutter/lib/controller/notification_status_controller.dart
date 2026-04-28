import 'package:dotto/domain/notification_alert_status.dart';
import 'package:dotto/helper/notification_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_status_controller.g.dart';

@riverpod
class NotificationStatusNotifier extends _$NotificationStatusNotifier {
  @override
  Future<NotificationAlertStatus> build() async {
    return ref.read(notificationHelperProvider).fetchAlertStatus();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(notificationHelperProvider).fetchAlertStatus(),
    );
  }
}
