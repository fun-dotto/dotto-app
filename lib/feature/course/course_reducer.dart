import 'package:dotto/feature/course/course_state.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_reducer.g.dart';

typedef Clock = DateTime Function();
typedef CourseCanFetchProtectedData = Future<bool> Function();

final clockProvider = Provider<Clock>((_) => DateTime.now);
final courseCanFetchProtectedDataProvider = Provider<CourseCanFetchProtectedData>((_) {
  return () async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      final idToken = await user.getIdToken();
      return idToken != null && idToken.isNotEmpty;
    } on Exception {
      return false;
    }
  };
});

@riverpod
final class CourseReducer extends _$CourseReducer {
  @override
  Future<CourseState> build() async {
    return _createCourseState();
  }

  Future<void> refresh() async {
    final nextState = await AsyncValue.guard(_createCourseState);
    if (!ref.mounted) {
      return;
    }
    state = nextState;
  }

  Future<CourseState> _createCourseState() async {
    final canFetchProtectedData = await ref.read(courseCanFetchProtectedDataProvider)();
    if (!ref.mounted || !canFetchProtectedData) {
      return const CourseState();
    }

    final personalCalendarRepository = ref.read(personalCalendarRepositoryProvider);

    final now = ref.read(clockProvider);
    final today = now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // 初期表示週の月曜日を決定
    // 平日 → 今週の月曜日、土日 → 翌週の月曜日
    final DateTime anchorMonday;
    if (todayDate.weekday <= DateTime.friday) {
      anchorMonday = todayDate.subtract(Duration(days: todayDate.weekday - 1));
    } else {
      anchorMonday = todayDate.add(Duration(days: DateTime.monday + 7 - todayDate.weekday));
    }

    // 4週間分の週を生成（初期表示週の1週前〜2週後）
    final weeks = List.generate(4, (i) {
      final weekMonday = anchorMonday.add(Duration(days: (i - 1) * 7));
      return List.generate(5, (j) => weekMonday.add(Duration(days: j)));
    });

    // 週ごとにAPIを呼び出し
    final weekResults = await Future.wait(
      weeks.map((weekDates) => personalCalendarRepository.getPersonalTimetableDays(targetDates: weekDates)),
    );
    if (!ref.mounted) {
      return const CourseState();
    }

    final days = weekResults.expand((week) => week).toList();
    return CourseState(days: days);
  }
}
