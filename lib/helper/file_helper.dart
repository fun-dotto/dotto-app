import 'dart:convert';
import 'dart:io';

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
    final filePath = await getApplicationFilePath(path);
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('File does not exist');
    }
    final jsonString = await file.readAsString();
    return jsonDecode(jsonString) as List<dynamic>;
  }
}
