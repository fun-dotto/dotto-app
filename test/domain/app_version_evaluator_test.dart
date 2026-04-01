import 'package:dotto/domain/app_version_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppVersionEvaluator', () {
    test('現在バージョンが最新かつ有効バージョン以上の場合は両方true', () {
      final result = AppVersionEvaluator.evaluate(
        currentAppVersion: '2.1.0',
        validAppVersion: '2.0.0',
        latestAppVersion: '2.1.0',
      );

      expect(result.isValidAppVersion, isTrue);
      expect(result.isLatestAppVersion, isTrue);
    });

    test('現在バージョンが有効バージョン未満の場合は強制アップデート対象', () {
      final result = AppVersionEvaluator.evaluate(
        currentAppVersion: '1.9.9',
        validAppVersion: '2.0.0',
        latestAppVersion: '2.1.0',
      );

      expect(result.isValidAppVersion, isFalse);
      expect(result.isLatestAppVersion, isFalse);
    });

    test('現在バージョンが有効だが最新でない場合はアップデート通知対象', () {
      final result = AppVersionEvaluator.evaluate(
        currentAppVersion: '2.0.1',
        validAppVersion: '2.0.0',
        latestAppVersion: '2.1.0',
      );

      expect(result.isValidAppVersion, isTrue);
      expect(result.isLatestAppVersion, isFalse);
    });

    test('パッチ桁省略でも比較できる', () {
      final result = AppVersionEvaluator.evaluate(
        currentAppVersion: '2.0',
        validAppVersion: '2.0.0',
        latestAppVersion: '2.0.1',
      );

      expect(result.isValidAppVersion, isTrue);
      expect(result.isLatestAppVersion, isFalse);
    });

    test('Remote Configバージョンが不正な場合は判定をバイパスする', () {
      final result = AppVersionEvaluator.evaluate(
        currentAppVersion: '2.0.0',
        validAppVersion: '',
        latestAppVersion: 'invalid',
      );

      expect(result.isValidAppVersion, isTrue);
      expect(result.isLatestAppVersion, isTrue);
    });
  });
}
