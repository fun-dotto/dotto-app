import 'package:dotto/helper/file_helper.dart';
import 'package:dotto/repository/model/one_week_schedule_entry.dart';

abstract class OneWeekScheduleRepository {
  Future<List<OneWeekScheduleEntry>> getSchedules();
}

final class OneWeekScheduleRepositoryImpl implements OneWeekScheduleRepository {
  OneWeekScheduleRepositoryImpl();

  @override
  Future<List<OneWeekScheduleEntry>> getSchedules() async {
    try {
      final data = await FileHelper.getJSONData('map/oneweek_schedule.json');
      return data
          .whereType<Map<String, dynamic>>()
          .map((entry) => entry.map((key, value) => MapEntry(key, value)))
          .map((entry) => OneWeekScheduleEntry.fromJson(entry))
          .whereType<OneWeekScheduleEntry>()
          .toList();
    } on Exception {
      return const <OneWeekScheduleEntry>[];
    }
  }
}
