import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_timetable_calendar_reducer.g.dart';

@riverpod
final class PersonalTimetableCalendarReducer extends _$PersonalTimetableCalendarReducer {
  @override
  Future<List<PersonalTimetableItem>> build() async {
    return const [];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return [];
    });
  }
}
