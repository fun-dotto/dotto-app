import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

final class InvalidAppVersionScreen extends StatelessWidget {
  const InvalidAppVersionScreen({
    required this.appStorePageUrl,
    required this.currentAppVersion,
    required this.latestAppVersion,
    super.key,
  });

  final String appStorePageUrl;
  final String currentAppVersion;
  final String latestAppVersion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dottoのアップデートが必要です',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: SemanticColor.light.accentPrimary),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 64,
          children: [
            Text('現在のバージョン: $currentAppVersion\n最新バージョン: $latestAppVersion', textAlign: TextAlign.center),
            DottoButton(
              onPressed: () => launchUrlString(appStorePageUrl, mode: LaunchMode.externalApplication),
              child: const Text('今すぐアップデート'),
            ),
          ],
        ),
      ),
    );
  }
}
