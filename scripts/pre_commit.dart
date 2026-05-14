#!/usr/bin/env dart
// CLIスクリプトのため、printによるコンソール出力を許可する。
// ignore_for_file: avoid_print

import 'dart:io';

const red = '\x1B[31m';
const reset = '\x1B[0m';

Future<void> main() async {
  final exitCode = await runPreCommitChecks();
  exit(exitCode);
}

Future<int> runPreCommitChecks() async {
  print('Running pre-commit checks...\n');

  final formatResult = await checkDartFormat();
  if (formatResult != 0) return formatResult;

  print('\n✅ All pre-commit checks passed!');
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
