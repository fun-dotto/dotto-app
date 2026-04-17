import 'dart:convert';
import 'dart:io';

import 'package:dotto/domain/domain_error.dart';
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
      if (response.statusCode != 200) {
        throw DomainError(
          type: DomainErrorType.server,
          message: 'Failed to fetch holidays: status ${response.statusCode}',
        );
      }
      final parsed = _tryParse(response.body);
      if (parsed == null) {
        throw const DomainError(
          type: DomainErrorType.invalidResponse,
          message: 'Failed to parse holidays JSON',
        );
      }
      await file.writeAsString(response.body, flush: true);
      return parsed;
    } on DomainError {
      final stale = await _readStaleCache(file);
      if (stale != null) return stale;
      rethrow;
    } on Exception catch (e, st) {
      final stale = await _readStaleCache(file);
      if (stale != null) return stale;
      throw DomainError.fromException(e: e, stackTrace: st);
    }
  }

  Future<Set<String>?> _readStaleCache(File file) async {
    // UI 起動経路で呼ばれるため、同期 I/O を避けて非同期 API を使う。
    // ignore: avoid_slow_async_io
    if (await file.exists()) {
      return _tryParse(await file.readAsString());
    }
    return null;
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
