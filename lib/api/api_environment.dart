import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_environment.g.dart';

@Riverpod(keepAlive: true)
final class ApiEnvironment extends _$ApiEnvironment {
  @override
  Environment build() {
    if (kReleaseMode) return Environment.production;
    return Environment.staging;
  }

  Environment get value => state;

  set value(Environment newValue) {
    state = newValue;
    _save();
  }

  Future<void> load() async {
    final environment = await UserPreferenceRepository.getString(UserPreferenceKeys.environment);
    if (environment != null) {
      state = Environment.values.firstWhere((e) => e.tag == environment, orElse: () => state);
    }
  }

  Future<void> _save() async {
    await UserPreferenceRepository.setString(UserPreferenceKeys.environment, state.tag);
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
    Environment.development => 'https://app-bff-api-dev-107577467292.asia-northeast1.run.app',
    Environment.staging => 'https://app-bff-api-stg-107577467292.asia-northeast1.run.app',
    Environment.qa => 'https://app-bff-api-qa-107577467292.asia-northeast1.run.app',
    Environment.production => 'https://app-bff-api-107577467292.asia-northeast1.run.app',
  };
}
