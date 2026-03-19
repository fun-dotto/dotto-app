import 'dart:io';

import 'package:dotto/asset.dart';
import 'package:dotto/helper/local_repository.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

final class SyllabusDatabaseHelper {
  static Future<Database> getDatabase() async {
    final path = await LocalRepository.getApplicationFilePath('syllabus.db');
    final data = await rootBundle.load(Asset.syllabus);
    final List<int> bytes = data.buffer.asUint8List();
    await File(path).writeAsBytes(bytes);
    return openDatabase(path);
  }
}
