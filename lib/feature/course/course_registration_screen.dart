import 'dart:async';

import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_semester.dart';
import 'package:dotto/feature/course/course_registration_reducer.dart';
import 'package:dotto/feature/course/select_course_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CourseRegistrationScreen extends HookConsumerWidget {
  const CourseRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courseRegistrationReducerProvider);
    final tabController = useTabController(
      initialLength: TimetableSemester.values.length,
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          ref.read(courseRegistrationReducerProvider.notifier).refresh(),
        );
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('科目登録'),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: tabController,
          tabs: TimetableSemester.values
              .map((e) => Tab(text: e.label))
              .toList(),
        ),
      ),
      body: switch (state) {
        AsyncData(value: final timetableItemsBySemester) => TabBarView(
          controller: tabController,
          children: TimetableSemester.values
              .map(
                (e) => _personalWeeklyTimetable(
                  context,
                  ref,
                  e,
                  timetableItemsBySemester[e] ?? const <TimetableItem>[],
                ),
              )
              .toList(),
        ),
        AsyncLoading() => _courseRegistrationSkeleton(context),
        AsyncError() => const Center(child: Text('データの取得に失敗しました')),
      },
    );
  }

  Widget _courseRegistrationSkeleton(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Table(
          columnWidths: {
            for (final e in Period.values) e.number: const FlexColumnWidth(),
          },
          children: <TableRow>[
            TableRow(
              children: DayOfWeek.weekdays
                  .map(
                    (e) => TableCell(
                      child: Center(
                        child: Text(
                          e.label,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            ...Period.values.map(
              (_) => TableRow(
                children: DayOfWeek.weekdays
                    .map((_) => _personalWeeklyTimetableCellSkeleton())
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox({
    required double height,
    double? width,
    double radius = 8,
  }) {
    return Shimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _personalWeeklyTimetableCellSkeleton() {
    return Container(
      margin: const EdgeInsets.all(2),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _skeletonBox(height: 14, width: 56, radius: 4),
          const SizedBox(height: 8),
          _skeletonBox(height: 12, width: 40, radius: 4),
        ],
      ),
    );
  }

  Widget _personalWeeklyTimetable(
    BuildContext context,
    WidgetRef ref,
    TimetableSemester semester,
    List<TimetableItem> timetableItems,
  ) {
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(courseRegistrationReducerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Table(
            columnWidths: {
              for (final e in Period.values) e.number: const FlexColumnWidth(),
            },
            children: <TableRow>[
              TableRow(
                children: DayOfWeek.weekdays
                    .map(
                      (e) => TableCell(
                        child: Center(
                          child: Text(
                            e.label,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              ...Period.values.map(
                (period) => TableRow(
                  children: DayOfWeek.weekdays.map((dayOfWeek) {
                    final filteredTimetableItems = timetableItems
                        .where(
                          (item) =>
                              item.slot?.dayOfWeek == dayOfWeek &&
                              item.slot?.period == period,
                        )
                        .toList();
                    final filteredRegisteredTimetableItems =
                        filteredTimetableItems
                            .where((item) => item.isAddedToTimetable ?? false)
                            .toList();
                    return _personalWeeklyTimetableCell(
                      context,
                      filteredRegisteredTimetableItems,
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
                            onChanged: () async {
                              await ref
                                  .read(
                                    courseRegistrationReducerProvider.notifier,
                                  )
                                  .refresh();
                            },
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
      ),
    );
  }

  Widget _personalWeeklyTimetableCell(
    BuildContext context,
    List<TimetableItem> registeredTimetableItems, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 100,
        child: registeredTimetableItems.isNotEmpty
            ? Column(
                children: registeredTimetableItems
                    .map(
                      (item) => Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
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
                child: Center(
                  child: Icon(Icons.add, color: Colors.grey.shade400),
                ),
              ),
      ),
    );
  }
}
