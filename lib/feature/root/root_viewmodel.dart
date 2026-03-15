import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/root/root_viewmodel_state.dart';
import 'package:dotto/feature/setting/controller/hope_continuation_user_key_controller.dart';
import 'package:dotto/helper/logger.dart';
import 'package:dotto/helper/notification_helper.dart';
import 'package:dotto/helper/remote_config_helper.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_viewmodel.g.dart';

@riverpod
class RootViewModel extends _$RootViewModel {
  @override
  Future<RootViewModelState> build() async {
    // Setup Remote Config
    await ref.read(remoteConfigHelperProvider).setup();
    // Setup Notification
    await ref.read(notificationHelperProvider).setupInteractedMessage();
    // Setup Logger
    await ref.read(loggerProvider).setup();
    // Setup Universal Links
    AppLinks().uriLinkStream
        .listen((event) {
          if (event.path != '/config/' || !event.hasQuery) return;
          final query = event.queryParameters;
          if (!query.containsKey('userkey')) return;
          final userKey = query['userkey'];
          if (userKey == null) return;
          final userKeyPattern = RegExp(r'^[a-zA-Z0-9]{16}$');
          if (userKey.isEmpty || (userKey.length == 16 && userKeyPattern.hasMatch(userKey))) {
            ref.read(hopeContinuationUserKeyProvider.notifier).set(userKey);
            return;
          }
        })
        .onError((Object error, StackTrace stackTrace) {
          debugPrint(error.toString());
        });
    // Refresh User and Save FCM Token
    await ref.read(userProvider.notifier).refresh();

    final hasShownAppTutorial =
        await UserPreferenceRepository.getBool(UserPreferenceKeys.isAppTutorialComplete) ?? false;

    final config = ref.read(configProvider);

    return RootViewModelState(
      selectedTab: TabItem.home,
      hasShownAppTutorial: hasShownAppTutorial,
      hasShownUpdateAlert: false,
      isValidAppVersion: config.isValidAppVersion,
      isLatestAppVersion: config.isLatestAppVersion,
      appStorePageUrl: config.appStorePageUrl,
      navigatorStates: {for (final tabItem in TabItem.values) tabItem: GlobalKey<NavigatorState>()},
    );
  }

  void onTabItemTapped(int index) {
    final selectedTab = TabItem.values.elementAtOrNull(index);
    if (selectedTab == null) {
      return;
    }
    if (state.value?.selectedTab != selectedTab) {
      state = AsyncValue.data(state.value!.copyWith(selectedTab: selectedTab));
      return;
    }
    // 同じタブを押すとルートまでPop
    final navigatorKey = state.value?.navigatorStates[selectedTab];
    if (navigatorKey == null) {
      return;
    }
    final currentState = navigatorKey.currentState;
    if (currentState == null) {
      return;
    }
    currentState.popUntil((Route<dynamic> route) => route.isFirst);

    ref.read(loggerProvider).logChangedTab(tabItem: selectedTab);
  }

  void onGoToSettingButtonTapped() {
    state = AsyncValue.data(state.value!.copyWith(selectedTab: TabItem.setting));
  }

  void onAppTutorialDismissed() {
    state = AsyncValue.data(state.value!.copyWith(hasShownAppTutorial: true));
    UserPreferenceRepository.setBool(UserPreferenceKeys.isAppTutorialComplete, value: true);
  }

  void onUpdateAlertShown() {
    state = AsyncValue.data(state.value!.copyWith(hasShownUpdateAlert: true));
  }
}
