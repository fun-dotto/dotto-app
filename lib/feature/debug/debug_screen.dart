import 'package:dotto/api/api_environment.dart';
import 'package:dotto/feature/search_subject/search_subject_screen.dart';
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

    useEffect(() {
      ref.read(apiEnvironmentProvider.notifier).load();
      return null;
    }, const []);

    void showEnvironmentPicker() {
      showDialog<void>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Environment'),
          children: Environment.values.map((env) {
            return MaterialButton(
              onPressed: () {
                ref.read(apiEnvironmentProvider.notifier).value = env;
                Navigator.of(context).pop();
              },
              child: ListTile(title: Text(env.name), trailing: Icon(env == environment ? Icons.check : null)),
            );
          }).toList(),
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
        body: Center(child: Text('Error: ${appCheckToken.error ?? idToken.error}')),
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
            subtitle: Text(environment.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: showEnvironmentPicker,
          ),
          ListTile(
            title: const Text('Search Subject'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const SearchSubjectScreen(),
                settings: const RouteSettings(name: '/search_subject'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
