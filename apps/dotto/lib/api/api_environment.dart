import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_environment.g.dart';

@Riverpod(keepAlive: true)
final class ApiEnvironment extends _$ApiEnvironment {
  Environment? _environmentOverride;

  @override
  Environment build() {
    return _effectiveEnvironment;
  }

  Environment get defaultEnvironment =>
      kReleaseMode ? Environment.production : Environment.staging;

  Environment get _effectiveEnvironment =>
      _environmentOverride ?? defaultEnvironment;

  Environment get value => state;

  Environment? get environmentOverride => _environmentOverride;

  Future<void> setOverride({required Environment? value}) async {
    _environmentOverride = value;
    if (value == null) {
      await UserPreferenceRepository.remove(
        UserPreferenceKeys.apiEnvironmentOverride,
      );
    } else {
      await UserPreferenceRepository.setString(
        UserPreferenceKeys.apiEnvironmentOverride,
        value.tag,
      );
    }
    state = _effectiveEnvironment;
  }

  Future<void> loadOverride() async {
    final overrideTag = await UserPreferenceRepository.getString(
      UserPreferenceKeys.apiEnvironmentOverride,
    );
    if (overrideTag != null) {
      _environmentOverride = Environment.values.firstWhere(
        (environment) => environment.tag == overrideTag,
        orElse: () => defaultEnvironment,
      );
    }
    state = _effectiveEnvironment;
  }
}

enum Environment {
  development,
  staging,
  qa,
  production;

  String get tag => switch (this) {
    Environment.development => 'dev',
    Environment.staging => 'stg',
    Environment.qa => 'qa',
    Environment.production => 'prod',
  };

  String get label => switch (this) {
    Environment.development => 'Development',
    Environment.staging => 'Staging',
    Environment.qa => 'QA',
    Environment.production => 'Production',
  };

  String get basePath => switch (this) {
    Environment.development =>
      'https://app-bff-api-dev-107577467292.asia-northeast1.run.app',
    Environment.staging =>
      'https://app-bff-api-stg-107577467292.asia-northeast1.run.app',
    Environment.qa =>
      'https://app-bff-api-qa-107577467292.asia-northeast1.run.app',
    Environment.production =>
      'https://app-bff-api-107577467292.asia-northeast1.run.app',
  };
}
