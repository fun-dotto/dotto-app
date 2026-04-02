import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/domain/tab_item.dart';
import 'package:dotto/feature/bus/bus.dart';
import 'package:dotto/feature/course/course_screen.dart';
import 'package:dotto/feature/funch/funch.dart';
import 'package:dotto/feature/home/home.dart';
import 'package:dotto/feature/map/map_screen.dart';
import 'package:dotto/feature/onboarding/onboarding_screen.dart';
import 'package:dotto/feature/root/root_viewmodel.dart';
import 'package:dotto/feature/setting/settings.dart';
import 'package:dotto/feature/subject/search_subject_screen.dart';
import 'package:dotto/widget/invalid_app_version_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  List<TabItem> _activeTabs({required bool isV2Enabled, required bool isFunchEnabled}) {
    final baseTabs = isV2Enabled ? TabItem.v2 : TabItem.v1;
    if (!isV2Enabled || isFunchEnabled) {
      return baseTabs;
    }
    return baseTabs.map((tab) => tab == TabItem.funch ? TabItem.subject : tab).toList();
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
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('あとで')),
        TextButton(
          onPressed: () => launchUrlString(appStorePageUrl, mode: LaunchMode.externalApplication),
          child: const Text('今すぐアップデート'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelAsync = ref.watch(rootViewModelProvider);
    final configFlags = ref.watch(configProvider.select((config) => (config.isV2Enabled, config.isFunchEnabled)));
    final activeTabs = _activeTabs(isV2Enabled: configFlags.$1, isFunchEnabled: configFlags.$2);

    switch (viewModelAsync) {
      case AsyncData(:final value):
        if (!value.hasShownAppTutorial) {
          debugPrint('Show App Tutorial');
          return OnboardingScreen(onDismissed: ref.read(rootViewModelProvider.notifier).onAppTutorialDismissed);
        }
        if (!value.isValidAppVersion) {
          debugPrint('Invalid App Version');
          return InvalidAppVersionScreen(
            appStorePageUrl: value.appStorePageUrl,
            currentAppVersion: value.currentAppVersion,
            latestAppVersion: value.latestAppVersion,
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!value.isLatestAppVersion && !value.hasShownUpdateAlert) {
            debugPrint('Not Latest App Version');
            ref.read(rootViewModelProvider.notifier).onUpdateAlertShown();
            showDialog<void>(
              context: context,
              builder: (context) => _updateAlertDialog(
                context: context,
                appStorePageUrl: value.appStorePageUrl,
                currentAppVersion: value.currentAppVersion,
                latestAppVersion: value.latestAppVersion,
              ),
            );
          }
        });

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Navigator(
            key: value.navigatorKeys[value.selectedTab],
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => switch (value.selectedTab) {
                  TabItem.course => const CourseScreen(),
                  TabItem.funch => const FunchScreen(),
                  TabItem.map => MapScreen(
                    onGoToSettingButtonTapped: () =>
                        ref.read(rootViewModelProvider.notifier).onGoToSettingButtonTapped(),
                  ),
                  TabItem.bus => const BusScreen(),
                  TabItem.setting => const SettingsScreen(),
                  TabItem.home => const HomeScreen(),
                  TabItem.subject => const SearchSubjectScreen(),
                },
              );
            },
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: ref.read(rootViewModelProvider.notifier).onTabItemTapped,
            selectedIndex: activeTabs.indexOf(value.selectedTab),
            destinations: activeTabs.map((tab) {
              return NavigationDestination(
                selectedIcon: Icon(tab.selectedIcon),
                icon: Icon(tab.icon),
                label: tab.label,
              );
            }).toList(),
          ),
        );

      case AsyncError(:final error):
        debugPrint('RootScreen Error: $error');
        return const SizedBox.shrink();

      case AsyncLoading():
        return const Scaffold(resizeToAvoidBottomInset: false, body: Center(child: CircularProgressIndicator()));
    }
  }
}
