#!/usr/bin/env dart

import 'dart:io';

const red = '\x1B[31m';
const reset = '\x1B[0m';

Future<void> main() async {
  final exitCode = await runPreCommitChecks();
  exit(exitCode);
}

Future<int> runPreCommitChecks() async {
  print('Running pre-commit checks...\n');

  // Check 1: .env.keys security check
  final envKeysResult = await checkEnvKeysSecurity();
  if (envKeysResult != 0) return envKeysResult;

  // Check 2: Dart format check
  final formatResult = await checkDartFormat();
  if (formatResult != 0) return formatResult;

  print('\n✅ All pre-commit checks passed!');
  return 0;
}

Future<int> checkEnvKeysSecurity() async {
  print('Checking .env.keys security...');

  // Get staged files
  final stagedResult = await Process.run('git', [
    'diff',
    '--cached',
    '--name-only',
    '--diff-filter=ACM',
  ]);
  final stagedFiles = (stagedResult.stdout as String)
      .trim()
      .split('\n')
      .where((f) => f.trim().isNotEmpty)
      .toList();

  // Check if .env.keys is staged
  if (stagedFiles.any((f) => f.endsWith('.env.keys'))) {
    print('$red❌ 重大なエラー: .env.keys ファイルはコミットできません！$reset');
    print('$red   このファイルには暗号化キーが含まれており、絶対にコミットしてはいけません。$reset');
    print('');
    print('ステージングから削除してください:');
    print('  git reset HEAD .env.keys');
    return 1;
  }

  // Check for unencrypted .env files
  final envFiles = stagedFiles
      .where(
        (f) =>
            RegExp(r'(^|/)\.env(\.|$)').hasMatch(f) && !f.endsWith('.env.keys'),
      )
      .toList();

  for (final envFile in envFiles) {
    // Get staged content
    final contentResult = await Process.run('git', ['show', ':0:$envFile']);

    if (contentResult.exitCode != 0) {
      final errorOutput = (contentResult.stderr as String?)?.trim();
      print('$red❌ エラー: git show でステージ済みの $envFile の内容を取得できませんでした。$reset');
      if (errorOutput != null && errorOutput.isNotEmpty) {
        print('git show のエラー出力:');
        print(errorOutput);
      }
      return 1;
    }

    String content = (contentResult.stdout as String).trim();
    // If empty, try to read from working tree (for new files)
    if (content.isEmpty && await File(envFile).exists()) {
      content = await File(envFile).readAsString();
    }

    if (content.isEmpty) continue;

    // Check for unencrypted lines
    final lines = content.split('\n');
    final unencryptedLines = lines.where((line) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) return false;
      if (trimmed.startsWith('#')) return false;
      if (trimmed.startsWith('DOTENV_PUBLIC_KEY=')) return false;
      if (trimmed.contains('encrypted:')) return false;
      return true;
    }).toList();

    if (unencryptedLines.isNotEmpty) {
      print('$red❌ エラー: $envFile 内に暗号化されていない行を検出しました！$reset');
      print('平文のままコミットしようとしている行:');
      for (final line in unencryptedLines) {
        // セキュリティのため、キー名のみ表示し値はマスクする
        final keyMatch = RegExp(r'^([^=]+)=').firstMatch(line);
        if (keyMatch != null) {
          print('$red  ${keyMatch.group(1)}=***$reset');
        } else {
          print('$red  (形式不明の行)$reset');
        }
      }
      print('');
      print('✅ 対応策:');
      print("1. 'dotenvx encrypt -f $envFile' を実行して暗号化してください。");
      print("2. その後、'git add $envFile' をして再度コミットしてください。");
      return 1;
    }
  }

  print('  ✓ .env.keys security check passed');
  return 0;
}

Future<int> checkDartFormat() async {
  print('Checking Dart format...');

  // Get staged .dart files
  final stagedResult = await Process.run('git', [
    'diff',
    '--cached',
    '--name-only',
    '--diff-filter=ACMR',
    '--',
    '*.dart',
  ]);
  if (stagedResult.exitCode != 0) {
    stderr.writeln('$red❌ ERROR: Failed to list staged Dart files.$reset');
    if (stagedResult.stderr != null &&
        stagedResult.stderr.toString().trim().isNotEmpty) {
      stderr.writeln(stagedResult.stderr);
    }
    return 1;
  }
  final allStagedDartFiles = (stagedResult.stdout as String)
      .split('\n')
      .map((f) => f.trim())
      .where((f) => f.isNotEmpty)
      .toList();

  // Filter out generated files and api directory
  final stagedDartFiles = allStagedDartFiles.where((f) {
    if (f.startsWith('api/')) return false;
    if (f.endsWith('.g.dart')) return false;
    if (f.endsWith('.freezed.dart')) return false;
    if (f.endsWith('.gen.dart')) return false;
    return true;
  }).toList();

  if (stagedDartFiles.isEmpty) {
    print('  ✓ No Dart files to check');
    return 0;
  }

  // Run dart format check
  final formatResult = await Process.run('dart', [
    'format',
    '--output=none',
    '--set-exit-if-changed',
    ...stagedDartFiles,
  ]);

  if (formatResult.exitCode != 0) {
    print('');
    print('$red❌ エラー: 一部のファイルがフォーマットされていません。$reset');
    final stdout = (formatResult.stdout as String).trim();
    final stderr = (formatResult.stderr as String).trim();
    if (stdout.isNotEmpty) {
      print(stdout);
    }
    if (stderr.isNotEmpty) {
      print(stderr);
    }
    print('');
    print("フォーマットを修正するには 'task format' を実行し、その後変更をステージしてください。");
    return 1;
  }

  print('  ✓ Dart format check passed');
  return 0;
}
