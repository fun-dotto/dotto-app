import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/course_registration.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/feature/course_registration/course_registration_repository.dart';
import 'package:dotto/feature/timetable/widget/timetable_is_over_selected_snack_bar.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SelectCourseScreen extends HookConsumerWidget {
  const SelectCourseScreen(
    this.semester,
    this.dayOfWeek,
    this.period,
    this.timetableItems,
    this.courseRegistrations, {
    super.key,
  });

  final Semester semester;
  final DayOfWeek dayOfWeek;
  final Period period;
  final List<TimetableItem> timetableItems;
  final List<CourseRegistration> courseRegistrations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);

    return Scaffold(
      appBar: AppBar(title: Text('${semester.label} ${dayOfWeek.label}曜${period.number}限')),
      body: () {
        if (timetableItems.isEmpty) {
          return const Center(child: Text('対象の科目はありません'));
        }
        return ListView.builder(
          itemCount: timetableItems.length,
          itemBuilder: (context, index) {
            final item = timetableItems[index];
            return ListTile(
              title: Text(item.subject.name),
              trailing: item.subject.isAddedToTimetable
                  ? DottoButton(
                      onPressed: () async {
                        final courseRegistration = courseRegistrations.firstWhere(
                          (e) => e.subject.id == item.subject.id,
                        );
                        await courseRegistrationRepository.unregisterCourse(courseRegistration.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      type: DottoButtonType.outlined,
                      child: const Text('削除'),
                    )
                  : DottoButton(
                      onPressed: () async {
                        if (courseRegistrations.length >= 3 && context.mounted) {
                          timetableIsOverSelectedSnackBar(context);
                          return;
                        }
                        await courseRegistrationRepository.registerCourse(item.subject.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('追加'),
                    ),
            );
          },
        );
      }(),
    );
  }
}
