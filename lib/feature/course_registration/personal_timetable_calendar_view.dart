import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course_registration/personal_timetable_calendar_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class PersonalTimetableCalendarView extends HookConsumerWidget {
  const PersonalTimetableCalendarView({required this.onSubjectSelected, super.key});

  final void Function(SubjectSummary) onSubjectSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      ref.read(personalTimetableCalendarReducerProvider.notifier).refresh();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('時間割')),
      body: const SizedBox.shrink(),
    );
  }
}
