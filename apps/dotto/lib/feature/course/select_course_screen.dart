import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/domain/timetable_semester.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class SelectCourseScreen extends HookConsumerWidget {
  const SelectCourseScreen(
    this.semester,
    this.dayOfWeek,
    this.period,
    this.timetableItems, {
    this.onChanged,
    super.key,
  });

  final TimetableSemester semester;
  final DayOfWeek dayOfWeek;
  final Period period;
  final List<TimetableItem> timetableItems;
  final Future<void> Function()? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(
      apiClient,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${semester.label} ${dayOfWeek.label}曜${period.number}限'),
      ),
      body: () {
        if (timetableItems.isEmpty) {
          return const Center(child: Text('対象の科目はありません'));
        }
        return ListView.builder(
          itemCount: timetableItems.length,
          itemBuilder: (context, index) {
            final item = timetableItems[index];
            final isAddedToTimetable = item.isAddedToTimetable ?? false;
            final selectedCount = timetableItems
                .where((e) => e.isAddedToTimetable ?? false)
                .length;
            return ListTile(
              title: Text(item.subject.name),
              trailing: isAddedToTimetable
                  ? DottoButton(
                      onPressed: () async {
                        final courseRegistrations =
                            await courseRegistrationRepository
                                .getCourseRegistrations(semester.semesters);
                        final targets = courseRegistrations.where(
                          (e) => e.subject.id == item.subject.id,
                        );
                        if (targets.isEmpty) {
                          return;
                        }
                        await courseRegistrationRepository.unregisterCourse(
                          targets.first.id,
                        );
                        await onChanged?.call();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      type: DottoButtonType.outlined,
                      child: const Text('削除'),
                    )
                  : DottoButton(
                      onPressed: () async {
                        if (selectedCount >= 2 && context.mounted) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('1つのコマに2科目以上を設定できません'),
                            ),
                          );
                          return;
                        }
                        await courseRegistrationRepository.registerCourse(
                          item.subject.id,
                        );
                        await onChanged?.call();
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
