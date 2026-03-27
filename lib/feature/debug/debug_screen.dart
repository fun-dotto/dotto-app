import 'package:dotto/api/api_environment.dart';
import 'package:dotto/controller/config_controller.dart';
import 'package:dotto/domain/remote_config_keys.dart';
import 'package:dotto/helper/remote_config_helper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class DebugScreen extends HookConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appCheckToken = useFuture(useMemoized(() => FirebaseAppCheck.instance.getToken()));
    final idToken = useFuture(useMemoized(() => FirebaseAuth.instance.currentUser?.getIdToken()));
    final environment = ref.watch(apiEnvironmentProvider);
    final config = ref.watch(configProvider);
    final configNotifier = ref.read(configProvider.notifier);
    final isV2EnabledOverride = configNotifier.isV2EnabledOverride;
    final remoteConfigIsV2Enabled = ref.read(remoteConfigHelperProvider).getBool(RemoteConfigKeys.isV2Enabled);

    Future<void> showEnvironmentPicker() async {
      await showDialog<void>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Environment'),
          children: Environment.values.map((env) {
            return MaterialButton(
              onPressed: () {
                ref.read(apiEnvironmentProvider.notifier).value = env;
                Navigator.of(context).pop();
              },
              child: ListTile(title: Text(env.label), trailing: Icon(env == environment ? Icons.check : null)),
            );
          }).toList(),
        ),
      );
    }

    Future<void> showIsV2EnabledOverridePicker() async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => SimpleDialog(
          title: const Text('isV2Enabled Override'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsV2EnabledOverride(value: null);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use Remote Config'),
                subtitle: Text('Remote Config: $remoteConfigIsV2Enabled'),
                trailing: isV2EnabledOverride == null ? const Icon(Icons.check) : null,
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsV2EnabledOverride(value: true);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Force true'),
                trailing: isV2EnabledOverride == true ? const Icon(Icons.check) : null,
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsV2EnabledOverride(value: false);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Force false'),
                trailing: isV2EnabledOverride == false ? const Icon(Icons.check) : null,
              ),
            ),
          ],
        ),
      );
    }

    if (appCheckToken.connectionState == ConnectionState.waiting ||
        idToken.connectionState == ConnectionState.waiting) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debug')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (appCheckToken.hasError || idToken.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debug')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: Text('${appCheckToken.error ?? idToken.error}')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Debug')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Check Access Token'),
            subtitle: Text(appCheckToken.data ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                if (appCheckToken.data == null) return;
                Clipboard.setData(ClipboardData(text: appCheckToken.data ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('クリップボードにコピーしました')));
              },
            ),
          ),
          ListTile(
            title: const Text('User ID Token'),
            subtitle: Text(idToken.data ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                if (idToken.data == null) return;
                Clipboard.setData(ClipboardData(text: idToken.data ?? ''));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('クリップボードにコピーしました')));
              },
            ),
          ),
          ListTile(
            title: const Text('Environment'),
            subtitle: Text(environment.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: showEnvironmentPicker,
          ),
          ListTile(
            title: const Text('isV2Enabled Override'),
            subtitle: Text(switch (isV2EnabledOverride) {
              true => 'Forced: true',
              false => 'Forced: false',
              null => 'Use Remote Config ($remoteConfigIsV2Enabled)',
            }),
            trailing: Text('Effective: ${config.isV2Enabled}'),
            onTap: showIsV2EnabledOverridePicker,
          ),
        ],
      ),
    );
  }
}
