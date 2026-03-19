import 'package:dotto/helper/syllabus_database_helper.dart';

final class CourseDatabaseHelper {
  static Future<List<Map<String, dynamic>>> searchCourses({
    required String whereClause,
    required String searchWord,
  }) async {
    final db = await SyllabusDatabaseHelper.getDatabase();
    final records = await db.query(
      'sort, detail',
      where: 'sort.LessonId=detail.LessonId AND ?',
      whereArgs: [whereClause],
    );
    return records.where((record) => record['授業名']?.toString().contains(searchWord) ?? false).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchWeekPeriod(List<int> lessonIdList) async {
    final db = await SyllabusDatabaseHelper.getDatabase();
    final records = await db.query('week_period', where: 'lessonId IN (?)', whereArgs: [lessonIdList.join(',')]);
    return records;
  }
}
