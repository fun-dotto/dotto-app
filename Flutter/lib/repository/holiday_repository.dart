import 'dart:convert';
import 'dart:io';

import 'package:dotto/helper/file_helper.dart';
import 'package:http/http.dart' as http;

abstract class HolidayRepository {
  Future<Set<String>> getHolidayDates();
}

final class HolidayRepositoryImpl implements HolidayRepository {
  static final Uri _endpoint = Uri.parse(
    'https://holidays-jp.github.io/api/v1/date.json',
  );
  static const String _cacheFilePath = 'holiday/date.json';
  static const Duration _cacheDuration = Duration(days: 1);
  static const Duration _requestTimeout = Duration(seconds: 10);

  @override
  Future<Set<String>> getHolidayDates() async {
    final filePath = await FileHelper.getApplicationFilePath(_cacheFilePath);
    final file = File(filePath);

    // UI 起動経路で呼ばれるため、同期 I/O を避けて非同期 API を使う。
    // ignore: avoid_slow_async_io
    if (await file.exists()) {
      // UI 起動経路で呼ばれるため、同期 I/O を避けて非同期 API を使う。
      // ignore: avoid_slow_async_io
      final age = DateTime.now().difference(await file.lastModified());
      if (age < _cacheDuration) {
        final parsed = _tryParse(await file.readAsString());
        if (parsed != null) return parsed;
      }
    }

    try {
      final response = await http.get(_endpoint).timeout(_requestTimeout);
      if (response.statusCode == 200) {
        final parsed = _tryParse(response.body);
        if (parsed != null) {
          await file.writeAsString(response.body, flush: true);
          return parsed;
        }
      }
    } on Exception {
      // ignore and fall through to stale cache / empty
    }

    // UI 起動経路で呼ばれるため、同期 I/O を避けて非同期 API を使う。
    // ignore: avoid_slow_async_io
    if (await file.exists()) {
      final parsed = _tryParse(await file.readAsString());
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
