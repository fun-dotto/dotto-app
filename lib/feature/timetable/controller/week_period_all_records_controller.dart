import 'package:dotto/helper/syllabus_database_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'week_period_all_records_controller.g.dart';

@riverpod
final class WeekPeriodAllRecordsNotifier extends _$WeekPeriodAllRecordsNotifier {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final db = await SyllabusDatabaseHelper.getDatabase();
    final records = await db.query('week_period', orderBy: 'lessonId');
    return records;
  }
}
