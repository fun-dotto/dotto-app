import 'dart:async';

import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/feature/course_registration/course_registration_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CourseRegistrationScreen extends HookConsumerWidget {
  const CourseRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
    final timetableItems = useState<AsyncValue<List<TimetableItem>>>(const AsyncLoading());
    final courseRegistrations = useState<AsyncValue<List<CourseRegistration>>>(const AsyncLoading());
    final tabController = useTabController(initialLength: Semester.onEditTimetableScreen.length);

    Future<void> refresh() async {
      timetableItems.value = const AsyncLoading();
      courseRegistrations.value = const AsyncLoading();
      Future.wait([
        courseRegistrationRepository
            .getTimetableItems(Semester.onEditTimetableScreen[tabController.index])
            .then(
              (value) => timetableItems.value = AsyncData(value),
              onError: (Object e, StackTrace st) => timetableItems.value = AsyncError(e, st),
            ),
        courseRegistrationRepository
            .getCourseRegistrations(Semester.onEditTimetableScreen[tabController.index])
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
          tabs: Semester.onEditTimetableScreen.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      body: switch (courseRegistrations.value) {
        AsyncData(:final value) => TabBarView(
          controller: tabController,
          children: Semester.onEditTimetableScreen.map((e) => _personalWeeklyTimetable(context, value)).toList(),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text(error.toString())),
      },
    );
  }

  Widget _personalWeeklyTimetable(BuildContext context, List<CourseRegistration> items) {
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
                children: DayOfWeek.weekdays
                    .map(
                      (dayOfWeek) => _personalWeeklyTimetableCell(
                        context,
                        items
                            .where((item) => item.subject.dayOfWeek == dayOfWeek && item.subject.period == period)
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _personalWeeklyTimetableCell(BuildContext context, List<CourseRegistration> items) {
    return InkWell(
      // 表示
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 100,
        child: items.isNotEmpty
            ? Column(
                children: items
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
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const Text("Unimplemented"),
            settings: const RouteSettings(name: '/course_registration/select_course'),
          ),
        );
      },
    );
  }
}
