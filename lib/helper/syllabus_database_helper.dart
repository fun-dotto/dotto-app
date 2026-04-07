import 'dart:io';

import 'package:dotto/asset.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqflite_logger.dart';

final class SyllabusDatabaseHelper {
  static Future<Database> getDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'syllabus.db');
    final exists = await databaseExists(path);
    if (!exists) {
      debugPrint('Creating new copy from asset');
      await Directory(dirname(path)).create(recursive: true);
      final data = await rootBundle.load(Asset.syllabus);
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      debugPrint('Database already exists');
    }
    debugPrint('Opening database: $path');
    if (kDebugMode) {
      final dbFactory = SqfliteDatabaseFactoryLogger(
        databaseFactory,
        options: SqfliteLoggerOptions(type: SqfliteDatabaseFactoryLoggerType.all),
      );
      return dbFactory.openDatabase(path);
    }
    return openDatabase(path, readOnly: true);
  }
}
