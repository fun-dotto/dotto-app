import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/feature/announcement/announcement_screen.dart';
import 'package:dotto/feature/assignment/setup_hope_continuity_screen.dart';
import 'package:dotto/feature/debug/debug_screen.dart';
import 'package:dotto/feature/github_contributor/github_contributor_screen.dart';
import 'package:dotto/feature/onboarding/onboarding_screen.dart';
import 'package:dotto/feature/setting/widget/license.dart';
import 'package:dotto/feature/setting/widget/user_info_tile.dart';
import 'package:dotto/feature/timetable/repository/timetable_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isAuthenticated = user.value?.id.isNotEmpty ?? false;
    final config = ref.watch(configProvider);

    // 設定を取得
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(configProvider.notifier).refresh();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('設定'), centerTitle: false),
      body: Column(
        children: [
          Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  tiles: <AbstractSettingsTile>[
                    user.when(
                      data: (value) => CustomSettingsTile(
                        child: UserInfoTile(
                          user: value,
                          onTap:
                              value
                                  .id
                                  .isNotEmpty // isAuthenticated の代わりに value.id をチェック
                              ? () => ref.read(userProvider.notifier).signOut()
                              : () async {
                                  await ref.read(userProvider.notifier).signIn();
                                  await TimetableRepository().loadPersonalTimetableListOnLogin(context, ref);
                                },
                        ),
                      ),
                      loading: () => CustomSettingsTile(child: SizedBox.shrink()),
                      error: (err, stack) => CustomSettingsTile(child: SizedBox.shrink()),
                    ),
                  ],
                ),
                SettingsSection(
                  tiles: <SettingsTile>[
                    // 学年
                    SettingsTile.navigation(
                      onPressed: (_) async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text('学年'),
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  ref.read(userProvider.notifier).setGrade(null);
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                  title: Text('なし'),
                                  trailing: Icon(user.value?.grade == null ? Icons.check : null),
                                ),
                              ),
                              ...Grade.values.map((grade) {
                                return MaterialButton(
                                  onPressed: () {
                                    ref.read(userProvider.notifier).setGrade(grade);
                                    Navigator.of(context).pop();
                                  },
                                  child: ListTile(
                                    title: Text(grade.label),
                                    trailing: Icon(user.value?.grade == grade ? Icons.check : null),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                      leading: const Icon(Icons.school),
                      title: const Text('学年'),
                      value: Text(user.value?.grade?.label ?? '未設定'),
                    ),
                    // コース
                    SettingsTile.navigation(
                      onPressed: (_) async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text('コース'),
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  ref.read(userProvider.notifier).setCourse(null);
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                  title: Text('なし'),
                                  trailing: Icon(user.value?.course == null ? Icons.check : null),
                                ),
                              ),
                              ...AcademicArea.values.map((academicArea) {
                                return MaterialButton(
                                  onPressed: () {
                                    ref.read(userProvider.notifier).setCourse(academicArea);
                                    Navigator.of(context).pop();
                                  },
                                  child: ListTile(
                                    title: Text(academicArea.label),
                                    trailing: Icon(user.value?.course == academicArea ? Icons.check : null),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                      leading: const Icon(Icons.school),
                      title: const Text('コース'),
                      value: Text(user.value?.course?.label ?? '未設定'),
                    ),
                    // クラス
                    SettingsTile.navigation(
                      onPressed: (_) async {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text('クラス'),
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  ref.read(userProvider.notifier).setClass(null);
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                  title: Text('なし'),
                                  trailing: Icon(user.value?.class_ == null ? Icons.check : null),
                                ),
                              ),
                              ...AcademicClass.values.map((academicClass) {
                                return MaterialButton(
                                  onPressed: () {
                                    ref.read(userProvider.notifier).setClass(academicClass);
                                    Navigator.of(context).pop();
                                  },
                                  child: ListTile(
                                    title: Text(academicClass.label),
                                    trailing: Icon(user.value?.class_ == academicClass ? Icons.check : null),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                      leading: const Icon(Icons.school),
                      title: const Text('クラス'),
                      value: Text(user.value?.class_?.label ?? '未設定'),
                    ),
                    // HOPE連携
                    SettingsTile.navigation(
                      title: const Text('HOPE連携'),
                      leading: const Icon(Icons.assignment),
                      onPressed: (_) {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => Scaffold(
                              appBar: AppBar(title: const Text('HOPE連携')),
                              body: SetupHopeContinuityScreen(
                                onUserKeySaved: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            settings: const RouteSettings(name: '/setting/hope_continuity'),
                          ),
                        );
                      },
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
                        onTap: () {
                          if (!kDebugMode) {
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
          ),
        ],
      ),
    );
  }
}
