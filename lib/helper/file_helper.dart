import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final class FileHelper {
  static Future<String> getApplicationFilePath(String path) async {
    final appDocDir = await getTemporaryDirectory();
    final fullPath = join(appDocDir.path, path);
    await Directory(dirname(fullPath)).create(recursive: true);
    return fullPath;
  }

  static Future<List<dynamic>> getJSONData(String path) async {
    try {
      final filePath = await getApplicationFilePath(path);
      final file = File(filePath);
      if (!file.existsSync()) {
        throw Exception('File does not exist');
      }
      const maxAttempts = 3;
      const retryDelay = Duration(milliseconds: 100);
      for (var attempt = 0; attempt < maxAttempts; attempt++) {
        final jsonString = await file.readAsString();
        if (jsonString.trim().isEmpty) {
          if (attempt < maxAttempts - 1) {
            await Future<void>.delayed(retryDelay);
            continue;
          } else {
            throw const FormatException('Empty JSON content');
          }
        }
        try {
          final decoded = jsonDecode(jsonString);
          if (decoded is List<dynamic>) {
            return decoded;
          } else {
            throw const FormatException('JSON content is not a List');
          }
        } on FormatException {
          if (attempt < maxAttempts - 1) {
            await Future<void>.delayed(retryDelay);
            continue;
          } else {
            rethrow;
          }
        }
      }
      throw const FormatException('Failed to read JSON data');
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
