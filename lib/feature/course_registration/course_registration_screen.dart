import 'dart:async';

import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_semester.dart';
import 'package:dotto/feature/course_registration/select_course_screen.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseRegistrationScreen extends HookConsumerWidget {
  const CourseRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
    final timetableRepository = TimetableRepositoryImpl(apiClient);
    final timetableItems = useState<AsyncValue<List<TimetableItem>>>(const AsyncLoading());
    final courseRegistrations = useState<AsyncValue<List<CourseRegistration>>>(const AsyncLoading());
    final tabController = useTabController(initialLength: TimetableSemester.values.length);

    Future<void> refresh() async {
      timetableItems.value = const AsyncLoading();
      courseRegistrations.value = const AsyncLoading();
      Future.wait([
        timetableRepository
            .getTimetableItems(TimetableSemester.values[tabController.index].semesters)
            .then(
              (value) => timetableItems.value = AsyncData(value),
              onError: (Object e, StackTrace st) => timetableItems.value = AsyncError(e, st),
            ),
        courseRegistrationRepository
            .getCourseRegistrations(TimetableSemester.values[tabController.index].semesters)
            .then(
              (value) => courseRegistrations.value = AsyncData(value),
              onError: (Object e, StackTrace st) => courseRegistrations.value = AsyncError(e, st),
            ),
      ]);
    }

    useEffect(() {
      unawaited(refresh());
      return null;
    }, const []);

    useEffect(() {
      unawaited(refresh());
      return null;
    }, [tabController.index]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('科目登録'),
        centerTitle: false,
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: tabController,
          tabs: TimetableSemester.values.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: switch ((timetableItems.value, courseRegistrations.value)) {
        (AsyncData(value: final timetableItems), AsyncData(value: final courseRegistrations)) => TabBarView(
          controller: tabController,
          children: TimetableSemester.values
              .map((e) => _personalWeeklyTimetable(context, e, timetableItems, courseRegistrations))
              .toList(),
        ),
        (AsyncLoading(), _) => const Center(child: CircularProgressIndicator()),
        (_, AsyncLoading()) => const Center(child: CircularProgressIndicator()),
        (AsyncError(), _) => const Center(child: Text('時間割の取得に失敗しました')),
        (_, AsyncError()) => const Center(child: Text('履修情報の取得に失敗しました')),
      },
    );
  }

  Widget _personalWeeklyTimetable(
    BuildContext context,
    TimetableSemester semester,
    List<TimetableItem> timetableItems,
    List<CourseRegistration> courseRegistrations,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Table(
          columnWidths: {for (final e in Period.values) e.number: const FlexColumnWidth()},
          children: <TableRow>[
            TableRow(
              children: DayOfWeek.weekdays
                  .map(
                    (e) => TableCell(
                      child: Center(child: Text(e.label, style: Theme.of(context).textTheme.labelMedium)),
                    ),
                  )
                  .toList(),
            ),
            ...Period.values.map(
              (period) => TableRow(
                children: DayOfWeek.weekdays.map((dayOfWeek) {
                  final filteredTimetableItems = timetableItems
                      .where((item) => item.subject.slot?.dayOfWeek == dayOfWeek && item.subject.slot?.period == period)
                      .toList();
                  final filteredCourseRegistrations = courseRegistrations
                      .where((item) => item.subject.slot?.dayOfWeek == dayOfWeek && item.subject.slot?.period == period)
                      .toList();
                  return _personalWeeklyTimetableCell(
                    context,
                    filteredTimetableItems,
                    filteredCourseRegistrations,
                    onTap: () async {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (_) => SelectCourseScreen(
                          semester,
                          dayOfWeek,
                          period,
                          filteredTimetableItems,
                          filteredCourseRegistrations,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalWeeklyTimetableCell(
    BuildContext context,
    List<TimetableItem> timetableItems,
    List<CourseRegistration> courseRegistrations, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 100,
        child: courseRegistrations.isNotEmpty
            ? Column(
                children: courseRegistrations
                    .map(
                      (item) => Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            item.subject.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Center(child: Icon(Icons.add, color: Colors.grey.shade400)),
              ),
      ),
    );
  }
}
