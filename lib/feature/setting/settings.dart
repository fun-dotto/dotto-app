import 'dart:io';

import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/feature/announcement/announcement_screen.dart';
import 'package:dotto/feature/debug/debug_screen.dart';
import 'package:dotto/feature/github_contributor/github_contributor_screen.dart';
import 'package:dotto/feature/onboarding/onboarding_screen.dart';
import 'package:dotto/feature/setting/controller/settings_controller.dart';
import 'package:dotto/feature/setting/repository/settings_repository.dart';
import 'package:dotto/feature/setting/widget/license.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<bool> canOpenDebugScreen() async {
    if (!kDebugMode) {
      return false;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    try {
      final tokenResult = await user.getIdTokenResult(true);
      final developerClaim = tokenResult.claims?['developer'];

      if (developerClaim is bool) {
        return developerClaim;
      }
      if (developerClaim is String) {
        return developerClaim.toLowerCase() == 'true';
      }
      if (developerClaim is num) {
        return developerClaim != 0;
      }
      return developerClaim != null;
    } on Exception {
      return false;
    }
  }

  Widget listDialog(BuildContext context, String title, UserPreferenceKeys userPreferenceKeys, List<String> list) {
    return AlertDialog(
      title: Text(title),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(list[index]),
                      onTap: () async {
                        await UserPreferenceRepository.setString(userPreferenceKeys, list[index]);
                        if (context.mounted) {
                          Navigator.of(context).pop(list[index]);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    final user = ref.watch(userProvider);
    final config = ref.watch(configProvider);

    // 設定を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(configProvider.notifier).refresh();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('設定'), centerTitle: false),
      body: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              // Googleでログイン
              SettingsTile.navigation(
                title: Text((user == null) ? 'ログイン' : 'ログイン中'),
                value: (Platform.isIOS)
                    ? (user == null)
                          ? null
                          : const Text('ログアウト')
                    : Text((user == null) ? 'Googleアカウント (@fun.ac.jp)' : '${user.email}でログイン中'),
                description: (Platform.isIOS)
                    ? Text((user == null) ? 'Googleアカウント (@fun.ac.jp)' : '${user.email}でログイン中')
                    : null,
                leading: Icon((user == null) ? Icons.login : Icons.logout),
                onPressed: (user == null)
                    ? (_) => SettingsRepository().onLogin(context, ref, (User? user) => userNotifier.user = user)
                    : (_) => SettingsRepository().onLogout(userNotifier.logout),
              ),
              // 学年
              SettingsTile.navigation(
                onPressed: (_) async {
                  final returnText = await showDialog<String>(
                    context: context,
                    builder: (_) {
                      return listDialog(context, '学年', UserPreferenceKeys.grade, ['なし', '1年', '2年', '3年', '4年']);
                    },
                  );
                  if (returnText != null) {
                    ref.invalidate(settingsGradeProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('学年'),
                value: Text(ref.watch(settingsGradeProvider).value ?? 'なし'),
              ),
              // コース
              SettingsTile.navigation(
                onPressed: (_) async {
                  final returnText = await showDialog<String>(
                    context: context,
                    builder: (_) {
                      return listDialog(context, 'コース', UserPreferenceKeys.course, [
                        'なし',
                        '情報システム',
                        '情報デザイン',
                        '知能',
                        '複雑',
                        '高度ICT',
                      ]);
                    },
                  );
                  if (returnText != null) {
                    ref.invalidate(settingsCourseProvider);
                  }
                },
                leading: const Icon(Icons.school),
                title: const Text('コース'),
                value: Text(ref.watch(settingsCourseProvider).value ?? 'なし'),
              ),
            ],
          ),

          // その他
          SettingsSection(
            tiles: <SettingsTile>[
              // お知らせ
              SettingsTile.navigation(
                title: const Text('お知らせ'),
                leading: const Icon(Icons.notifications),
                onPressed: (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AnnouncementScreen(),
                      settings: const RouteSettings(name: '/setting/announcement'),
                    ),
                  );
                },
              ),
              // フィードバック
              SettingsTile.navigation(
                title: const Text('フィードバックを送る'),
                leading: const Icon(Icons.messenger_rounded),
                onPressed: (_) {
                  launchUrlString(config.feedbackFormUrl);
                },
              ),
              // Contributors表示
              SettingsTile.navigation(
                title: const Text('開発者'),
                leading: const Icon(Icons.person),
                onPressed: (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const GitHubContributorScreen(),
                      settings: const RouteSettings(name: '/setting/github_contributors'),
                    ),
                  );
                },
              ),
              // アプリの使い方
              SettingsTile.navigation(
                title: const Text('アプリの使い方'),
                leading: const Icon(Icons.assignment),
                onPressed: (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OnboardingScreen(onDismissed: () => Navigator.of(context).pop()),
                      settings: const RouteSettings(name: '/setting/app_tutorial'),
                    ),
                  );
                },
              ),
              // 利用規約
              SettingsTile.navigation(
                title: const Text('利用規約'),
                leading: const Icon(Icons.verified_user),
                onPressed: (_) {
                  launchUrlString(config.termsOfServiceUrl);
                },
              ),
              // プライバシーポリシー
              SettingsTile.navigation(
                title: const Text('プライバシーポリシー'),
                leading: const Icon(Icons.admin_panel_settings),
                onPressed: (_) {
                  launchUrlString(config.privacyPolicyUrl);
                },
              ),
              // ライセンス
              SettingsTile.navigation(
                title: const Text('ライセンス'),
                leading: const Icon(Icons.info),
                onPressed: (_) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsLicenseScreen(),
                      settings: const RouteSettings(name: '/setting/license'),
                    ),
                  );
                },
                // バージョン
                description: GestureDetector(
                  onTap: () async {
                    final canOpen = await canOpenDebugScreen();
                    if (!canOpen || !context.mounted) {
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DebugScreen()));
                  },
                  child: FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Text('${data.version} (${data.buildNumber})');
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
