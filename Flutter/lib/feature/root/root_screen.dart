import 'dart:io';

import 'package:dotto/api/api_environment.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/notification_status_controller.dart';
import 'package:dotto/domain/notification_alert_status.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/bus/bus_screen.dart';
import 'package:dotto/feature/course/course_screen.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/map/map_screen.dart';
import 'package:dotto/feature/onboarding/onboarding_screen.dart';
import 'package:dotto/feature/root/root_viewmodel.dart';
import 'package:dotto/feature/setting/settings.dart';
import 'package:dotto/feature/subject/search_subject_screen.dart';
import 'package:dotto/helper/firebase_auth_provider.dart';
import 'package:dotto/helper/firebase_messaging_provider.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/notification_helper.dart';
import 'package:dotto/helper/url_launcher_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:dotto/widget/invalid_app_version_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class RootScreen extends HookConsumerWidget {
  const RootScreen({super.key});

  List<TabItem> _activeTabs({required bool isFunchEnabled}) {
    final baseTabs = TabItem.v2;
    if (isFunchEnabled) {
      return baseTabs;
    }
    return baseTabs
        .map((tab) => tab == TabItem.funch ? TabItem.subject : tab)
        .toList();
  }

  Widget _tabRoot({required TabItem tab, required WidgetRef ref}) {
    return switch (tab) {
      TabItem.course => const CourseScreen(),
      TabItem.funch => const FunchScreen(),
      TabItem.map => MapScreen(
        onGoToSettingButtonTapped: () => ref
            .read(rootViewModelProvider.notifier)
            .onGoToSettingButtonTapped(),
      ),
      TabItem.bus => const BusScreen(),
      TabItem.setting => const SettingsScreen(),
      TabItem.subject => const SearchSubjectScreen(),
    };
  }

  static const _notificationPromptCooldown = Duration(days: 7);

  Future<bool> _shouldPromptNotification(NotificationAlertStatus status) async {
    if (!status.shouldPromptUser) return false;
    if (kDebugMode) return true;
    final lastShown = await UserPreferenceRepository.getInt(
      UserPreferenceKeys.notificationPromptLastShownAt,
    );
    if (lastShown == null) return true;
    final elapsed = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(lastShown),
    );
    return elapsed >= _notificationPromptCooldown;
  }

  Widget _notificationAlertDialog({
    required BuildContext context,
    required WidgetRef ref,
    required NotificationAlertStatus status,
  }) {
    final message = switch (status) {
      NotificationAlertStatus.denied =>
        '通知が拒否されています。休講・補講・教室変更などのお知らせを受け取るには、設定アプリから通知を許可してください。',
      NotificationAlertStatus.provisional =>
        '現在は静かな配信のみ許可されています。'
            '休講・補講・教室変更などのお知らせをバナーやサウンドで受け取るには、'
            '設定アプリから通知を許可してください。',
      NotificationAlertStatus.alertDisabled =>
        '通知バナーが無効になっています。休講・補講・教室変更などのお知らせを目立つ形で受け取るには、設定アプリから通知バナーを有効にしてください。',
      NotificationAlertStatus.enabled ||
      NotificationAlertStatus.notDetermined => '',
    };
    return AlertDialog(
      title: const Text('通知を有効にしますか？'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('あとで'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await ref.read(notificationHelperProvider).openSystemSettings();
          },
          child: const Text('設定を開く'),
        ),
      ],
    );
  }

  Widget _updateAlertDialog({
    required BuildContext context,
    required String appStorePageUrl,
    required String currentAppVersion,
    required String latestAppVersion,
  }) {
    return AlertDialog(
      title: const Text('アップデートが必要です'),
      content: Text('現在のバージョン: $currentAppVersion\n最新バージョン: $latestAppVersion'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('あとで'),
        ),
        TextButton(
          onPressed: () =>
              launchUrlSafely(appStorePageUrl, mode: .externalApplication),
          child: const Text('今すぐアップデート'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      final listener = AppLifecycleListener(
        onResume: () => ref.invalidate(notificationStatusProvider),
      );
      return listener.dispose;
    }, const []);

    ref
      ..listen(firebaseAuthStateChangesProvider, (prev, next) async {
        final fcmTokenRepository = ref.read(fcmTokenRepositoryProvider);
        final logger = ref.read(loggerProvider);
        try {
          final prevUser = prev?.asData?.value;
          final nextUser = next.asData?.value;
          if (prevUser?.uid == nextUser?.uid) return;

          if (nextUser == null) return;
          final token = await FirebaseMessaging.instance.getToken();
          if (token == null) return;
          await fcmTokenRepository.upsertToken(token: token);
        } on Object catch (error, stackTrace) {
          await logger.logError(
            error,
            stackTrace,
            reason: 'firebaseAuthStateChangesProvider listener failed',
          );
        }
      })
      ..listen(fcmTokenRefreshStreamProvider, (_, next) async {
        final fcmTokenRepository = ref.read(fcmTokenRepositoryProvider);
        final logger = ref.read(loggerProvider);
        try {
          final token = next.value;
          if (token == null) return;
          if (FirebaseAuth.instance.currentUser == null) return;
          await fcmTokenRepository.upsertToken(token: token);
        } on Object catch (error, stackTrace) {
          await logger.logError(
            error,
            stackTrace,
            reason: 'fcmTokenRefreshStreamProvider listener failed',
          );
        }
      });

    final viewModelAsync = ref.watch(rootViewModelProvider);
    final environment = ref.watch(apiEnvironmentProvider);
    final isFunchEnabled = ref.watch(
      configProvider.select((config) => config.isFunchEnabled),
    );
    final activeTabs = _activeTabs(isFunchEnabled: isFunchEnabled);

    switch (viewModelAsync) {
      case AsyncData(:final value):
        if (!value.hasShownAppTutorial) {
          return OnboardingScreen(
            onDismissed: ref
                .read(rootViewModelProvider.notifier)
                .onAppTutorialDismissed,
          );
        }
        if (!value.isValidAppVersion) {
          return InvalidAppVersionScreen(
            appStorePageUrl: value.appStorePageUrl,
            currentAppVersion: value.currentAppVersion,
            latestAppVersion: value.latestAppVersion,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // 同一フレーム内で複数のコールバックが積まれたときに重複表示しない
          // よう、コールバック実行時点の最新状態を再取得して判定する。
          final latest = ref.read(rootViewModelProvider).value;
          if (latest == null) return;

          if (!latest.isLatestAppVersion && !latest.hasShownUpdateAlert) {
            ref.read(rootViewModelProvider.notifier).onUpdateAlertShown();
            await showDialog<void>(
              context: context,
              builder: (context) => _updateAlertDialog(
                context: context,
                appStorePageUrl: latest.appStorePageUrl,
                currentAppVersion: latest.currentAppVersion,
                latestAppVersion: latest.latestAppVersion,
              ),
            );
          }

          if (!context.mounted) return;
          final afterUpdate = ref.read(rootViewModelProvider).value;
          if (afterUpdate == null || afterUpdate.hasShownNotificationAlert) {
            return;
          }

          try {
            final status = await ref.read(notificationStatusProvider.future);
            if (!context.mounted) return;
            final current = ref.read(rootViewModelProvider).value;
            if (current == null || current.hasShownNotificationAlert) {
              return;
            }
            if (await _shouldPromptNotification(status)) {
              if (!context.mounted) return;
              ref
                  .read(rootViewModelProvider.notifier)
                  .markNotificationAlertShown();
              await showDialog<void>(
                context: context,
                builder: (context) => _notificationAlertDialog(
                  context: context,
                  ref: ref,
                  status: status,
                ),
              );
            } else {
              ref
                  .read(rootViewModelProvider.notifier)
                  .markNotificationAlertEvaluated();
            }
          } on Object catch (error, stackTrace) {
            await ref
                .read(loggerProvider)
                .logError(
                  error,
                  stackTrace,
                  reason: 'notificationStatusProvider read failed',
                );
            ref
                .read(rootViewModelProvider.notifier)
                .markNotificationAlertEvaluated();
          }
        });

        return PopScope(
          canPop: Platform.isIOS,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            await value.navigatorKeys[value.selectedTab]?.currentState
                ?.maybePop();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: activeTabs.indexOf(value.selectedTab),
              children: activeTabs.map((tab) {
                return Navigator(
                  key: value.navigatorKeys[tab],
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => _tabRoot(tab: tab, ref: ref),
                      settings: RouteSettings(name: '/${tab.name}'),
                    );
                  },
                );
              }).toList(),
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: switch (environment) {
                Environment.production => null,
                Environment.staging => Colors.orange.withValues(alpha: 0.15),
                Environment.development => Colors.blue.withValues(alpha: 0.15),
                Environment.qa => Colors.purple.withValues(alpha: 0.15),
              },
              onDestinationSelected: ref
                  .read(rootViewModelProvider.notifier)
                  .onTabItemTapped,
              selectedIndex: activeTabs.indexOf(value.selectedTab),
              destinations: activeTabs.map((tab) {
                return NavigationDestination(
                  selectedIcon: Icon(tab.selectedIcon),
                  icon: Icon(tab.icon),
                  label: tab.label,
                );
              }).toList(),
            ),
          ),
        );

      case AsyncError():
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('データの読み込みに失敗しました'),
          ),
        );

      case AsyncLoading():
        return const Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(child: CircularProgressIndicator()),
        );
    }
  }
}
