import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/personal_timetable_day.dart';
import 'package:dotto/feature/course/course_reducer.dart';
import 'package:dotto/repository/personal_calendar_repository.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final class FakePersonalCalendarRepository implements PersonalCalendarRepository {
  FakePersonalCalendarRepository({this.result = const []});

  final List<PersonalTimetableDay> result;
  final List<List<DateTime>> capturedCalls = [];

  @override
  Future<List<PersonalTimetableDay>> getPersonalTimetableDays({required List<DateTime> targetDates}) async {
    capturedCalls.add(targetDates);
    return result.where((day) => targetDates.any((d) => _isSameDate(d, day.date))).toList();
  }

  bool _isSameDate(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

void main() {
  ProviderContainer createContainer({
    required FakePersonalCalendarRepository personalCalendarRepository,
    bool isAuthenticated = true,
    DateTime Function() clock = _defaultClock,
  }) {
    return ProviderContainer(
      overrides: [
        personalCalendarRepositoryProvider.overrideWithValue(personalCalendarRepository),
        courseCanFetchProtectedDataProvider.overrideWithValue(() async => isAuthenticated),
        clockProvider.overrideWithValue(clock),
      ],
    );
  }

  // 2026-04-08 は水曜日
  // anchorMonday = 2026-04-06
  // 4週間: 2026-03-30〜04-03, 04-06〜04-10, 04-13〜04-17, 04-20〜04-24
  test('build は4週間分を週ごとにAPIを呼び出して days に反映する', () async {
    final personalCalendarRepository = FakePersonalCalendarRepository(
      result: [PersonalTimetableDay(date: DateTime(2026, 4, 6), items: const [], timetableDayOfWeek: DayOfWeek.monday)],
    );

    final container = createContainer(personalCalendarRepository: personalCalendarRepository);
    addTearDown(container.dispose);

    final state = await container.read(courseReducerProvider.future);

    expect(state.days, hasLength(1));

    // 週ごとに4回呼び出される
    expect(personalCalendarRepository.capturedCalls, hasLength(4));

    // 各週は平日5日
    for (final dates in personalCalendarRepository.capturedCalls) {
      expect(dates, hasLength(5));
      expect(dates.every((d) => d.weekday <= DateTime.friday), isTrue);
    }

    // 1週目: 前週 (3/30〜4/3)
    expect(personalCalendarRepository.capturedCalls[0].first, DateTime(2026, 3, 30));
    expect(personalCalendarRepository.capturedCalls[0].last, DateTime(2026, 4, 3));
    // 2週目: 今週 (4/6〜4/10)
    expect(personalCalendarRepository.capturedCalls[1].first, DateTime(2026, 4, 6));
    expect(personalCalendarRepository.capturedCalls[1].last, DateTime(2026, 4, 10));
    // 3週目 (4/13〜4/17)
    expect(personalCalendarRepository.capturedCalls[2].first, DateTime(2026, 4, 13));
    expect(personalCalendarRepository.capturedCalls[2].last, DateTime(2026, 4, 17));
    // 4週目 (4/20〜4/24)
    expect(personalCalendarRepository.capturedCalls[3].first, DateTime(2026, 4, 20));
    expect(personalCalendarRepository.capturedCalls[3].last, DateTime(2026, 4, 24));
  });

  test('土日の場合は翌週が基準週になる', () async {
    final personalCalendarRepository = FakePersonalCalendarRepository();

    // 2026-04-11 は土曜日 → anchorMonday = 2026-04-13
    final container = createContainer(
      personalCalendarRepository: personalCalendarRepository,
      clock: () => DateTime(2026, 4, 11, 12),
    );
    addTearDown(container.dispose);

    await container.read(courseReducerProvider.future);

    // 前週: 4/6〜4/10
    expect(personalCalendarRepository.capturedCalls[0].first, DateTime(2026, 4, 6));
    // 基準週: 4/13〜4/17
    expect(personalCalendarRepository.capturedCalls[1].first, DateTime(2026, 4, 13));
  });

  test('未認証時は PersonalTimetableDay を取得しない', () async {
    final personalCalendarRepository = FakePersonalCalendarRepository();

    final container = createContainer(personalCalendarRepository: personalCalendarRepository, isAuthenticated: false);
    addTearDown(container.dispose);

    final state = await container.read(courseReducerProvider.future);

    expect(state.days, isEmpty);
    expect(personalCalendarRepository.capturedCalls, isEmpty);
  });
}

DateTime _defaultClock() => DateTime(2026, 4, 8, 12);
