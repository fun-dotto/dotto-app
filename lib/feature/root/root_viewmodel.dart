import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/domain/app_version_evaluator.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/root/root_viewmodel_state.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/notification_helper.dart';
import 'package:dotto/helper/remote_config_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_viewmodel.g.dart';

@riverpod
class RootViewModel extends _$RootViewModel {
  List<TabItem> _activeTabs({required bool isV2Enabled, required bool isFunchEnabled}) {
    final baseTabs = isV2Enabled ? TabItem.v2 : TabItem.v1;
    if (!isV2Enabled || isFunchEnabled) {
      return baseTabs;
    }
    return baseTabs.map((tab) => tab == TabItem.funch ? TabItem.subject : tab).toList();
  }

  @override
  Future<RootViewModelState> build() async {
    // Setup Remote Config
    await ref.read(remoteConfigHelperProvider).setup();
    // Load local debug overrides
    await ref.read(configProvider.notifier).loadOverrides();
    // Setup Notification
    await ref.read(notificationHelperProvider).setupInteractedMessage();
    // Setup Logger
    await ref.read(loggerProvider).setup();
    // Setup Universal Links
    AppLinks().uriLinkStream.listen((event) {}).onError((Object error, StackTrace stackTrace) {
      debugPrint(error.toString());
    });

    final hasShownAppTutorial =
        await UserPreferenceRepository.getBool(UserPreferenceKeys.isAppTutorialComplete) ?? false;

    final config = ref.read(configProvider);
    final currentAppVersion = (await PackageInfo.fromPlatform()).version;
    final versionEvaluation = AppVersionEvaluator.evaluate(
      currentAppVersion: currentAppVersion,
      validAppVersion: config.validAppVersion,
      latestAppVersion: config.latestAppVersion,
    );
    final tabs = _activeTabs(isV2Enabled: config.isV2Enabled, isFunchEnabled: config.isFunchEnabled);

    ref.listen(configProvider, (_, next) {
      final currentState = switch (state) {
        AsyncData(:final value) => value,
        _ => null,
      };
      if (currentState == null) return;

      final activeTabs = _activeTabs(isV2Enabled: next.isV2Enabled, isFunchEnabled: next.isFunchEnabled);
      final nextVersionEvaluation = AppVersionEvaluator.evaluate(
        currentAppVersion: currentAppVersion,
        validAppVersion: next.validAppVersion,
        latestAppVersion: next.latestAppVersion,
      );
      state = AsyncValue.data(
        currentState.copyWith(
          selectedTab: activeTabs.contains(currentState.selectedTab) ? currentState.selectedTab : activeTabs.first,
          isValidAppVersion: nextVersionEvaluation.isValidAppVersion,
          isLatestAppVersion: nextVersionEvaluation.isLatestAppVersion,
          currentAppVersion: currentAppVersion,
          latestAppVersion: next.latestAppVersion,
          appStorePageUrl: next.appStorePageUrl,
        ),
      );
    });

    return RootViewModelState(
      selectedTab: tabs.first,
      hasShownAppTutorial: hasShownAppTutorial,
      hasShownUpdateAlert: false,
      isValidAppVersion: versionEvaluation.isValidAppVersion,
      isLatestAppVersion: versionEvaluation.isLatestAppVersion,
      currentAppVersion: currentAppVersion,
      latestAppVersion: config.latestAppVersion,
      appStorePageUrl: config.appStorePageUrl,
      navigatorKeys: {for (final tabItem in TabItem.values) tabItem: GlobalKey<NavigatorState>()},
    );
  }

  void onTabItemTapped(int index) {
    final config = ref.read(configProvider);
    final activeTabs = _activeTabs(isV2Enabled: config.isV2Enabled, isFunchEnabled: config.isFunchEnabled);
    final selectedTab = activeTabs.elementAtOrNull(index);
    if (selectedTab == null) {
      return;
    }
    if (state.value?.selectedTab != selectedTab) {
      state = AsyncValue.data(state.value!.copyWith(selectedTab: selectedTab));
      return;
    }
    // 同じタブを押すとルートまでPop
    final navigatorKey = state.value?.navigatorKeys[selectedTab];
    if (navigatorKey == null) {
      return;
    }
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.popUntil((route) => route.isFirst);

    unawaited(ref.read(loggerProvider).logChangedTab(tabItem: selectedTab));
  }

  void onGoToSettingButtonTapped() {
    state = AsyncValue.data(state.value!.copyWith(selectedTab: TabItem.setting));
  }

  void onAppTutorialDismissed() {
    state = AsyncValue.data(state.value!.copyWith(hasShownAppTutorial: true));
    unawaited(UserPreferenceRepository.setBool(UserPreferenceKeys.isAppTutorialComplete, value: true));
  }

  void onUpdateAlertShown() {
    state = AsyncValue.data(state.value!.copyWith(hasShownUpdateAlert: true));
  }
}
