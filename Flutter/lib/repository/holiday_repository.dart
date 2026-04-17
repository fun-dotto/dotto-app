import 'dart:convert';

import 'package:dotto/domain/user_preference_keys.dart';
import 'package:dotto/helper/user_preference_repository.dart';
import 'package:http/http.dart' as http;

abstract class HolidayRepository {
  Future<Set<String>> getHolidayDates();
}

final class HolidayRepositoryImpl implements HolidayRepository {
  static final Uri _endpoint = Uri.parse(
    'https://holidays-jp.github.io/api/v1/date.json',
  );
  static const Duration _cacheDuration = Duration(days: 1);

  @override
  Future<Set<String>> getHolidayDates() async {
    final cachedJson = await UserPreferenceRepository.getString(
      UserPreferenceKeys.holidayCacheJson,
    );
    final fetchedAt = await UserPreferenceRepository.getInt(
      UserPreferenceKeys.holidayCacheFetchedAt,
    );

    final now = DateTime.now();
    final isFresh = cachedJson != null &&
        fetchedAt != null &&
        now.millisecondsSinceEpoch - fetchedAt < _cacheDuration.inMilliseconds;

    if (isFresh) {
      final parsed = _tryParse(cachedJson);
      if (parsed != null) return parsed;
    }

    try {
      final response = await http.get(_endpoint);
      if (response.statusCode == 200) {
        final parsed = _tryParse(response.body);
        if (parsed != null) {
          await UserPreferenceRepository.setString(
            UserPreferenceKeys.holidayCacheJson,
            response.body,
          );
          await UserPreferenceRepository.setInt(
            UserPreferenceKeys.holidayCacheFetchedAt,
            now.millisecondsSinceEpoch,
          );
          return parsed;
        }
      }
    } on Exception {
      // ignore and fall through to stale cache / empty
    }

    if (cachedJson != null) {
      final parsed = _tryParse(cachedJson);
      if (parsed != null) return parsed;
    }
    return <String>{};
  }

  Set<String>? _tryParse(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return decoded.keys.map((e) => e.toString()).toSet();
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}
