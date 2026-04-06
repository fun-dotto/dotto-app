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
    final apiEnvironmentNotifier = ref.read(apiEnvironmentProvider.notifier);
    final environmentOverride = apiEnvironmentNotifier.environmentOverride;
    final config = ref.watch(configProvider);
    final configNotifier = ref.read(configProvider.notifier);
    final isFunchEnabledOverride = configNotifier.isFunchEnabledOverride;
    final remoteConfigIsFunchEnabled = ref.read(remoteConfigHelperProvider).getBool(RemoteConfigKeys.isFunchEnabled);

    Future<void> showEnvironmentPicker() async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => SimpleDialog(
          title: const Text('API Environment Override'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await apiEnvironmentNotifier.setOverride(value: null);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use Default'),
                subtitle: Text('Default: ${apiEnvironmentNotifier.defaultEnvironment.label}'),
                trailing: environmentOverride == null ? const Icon(Icons.check) : null,
              ),
            ),
            ...Environment.values.map((env) {
              return SimpleDialogOption(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await apiEnvironmentNotifier.setOverride(value: env);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Force ${env.label}'),
                  trailing: environmentOverride == env ? const Icon(Icons.check) : null,
                ),
              );
            }),
          ],
        ),
      );
    }

    Future<void> showIsFunchEnabledOverridePicker() async {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => SimpleDialog(
          title: const Text('isFunchEnabled Override'),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsFunchEnabledOverride(value: null);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use Remote Config'),
                subtitle: Text('Remote Config: $remoteConfigIsFunchEnabled'),
                trailing: isFunchEnabledOverride == null ? const Icon(Icons.check) : null,
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsFunchEnabledOverride(value: true);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Force true'),
                trailing: isFunchEnabledOverride == true ? const Icon(Icons.check) : null,
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await configNotifier.setIsFunchEnabledOverride(value: false);
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Force false'),
                trailing: isFunchEnabledOverride == false ? const Icon(Icons.check) : null,
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
            title: const Text('API Environment Override'),
            subtitle: Text(switch (environmentOverride) {
              null => 'Use Default (${apiEnvironmentNotifier.defaultEnvironment.label})',
              final value => 'Forced: ${value.label}',
            }),
            trailing: Text('Effective: ${environment.label}'),
            onTap: showEnvironmentPicker,
          ),
          ListTile(
            title: const Text('isFunchEnabled Override'),
            subtitle: Text(switch (isFunchEnabledOverride) {
              true => 'Forced: true',
              false => 'Forced: false',
              null => 'Use Remote Config ($remoteConfigIsFunchEnabled)',
            }),
            trailing: Text('Effective: ${config.isFunchEnabled}'),
            onTap: showIsFunchEnabledOverridePicker,
          ),
        ],
      ),
    );
  }
}
