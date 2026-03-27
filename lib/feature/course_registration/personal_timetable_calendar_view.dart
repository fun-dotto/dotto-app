import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/course_registration/personal_timetable_calendar_service.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class PersonalTimetableCalendarView extends HookConsumerWidget {
  const PersonalTimetableCalendarView({required this.onSubjectSelected, super.key});

  final void Function(SubjectSummary) onSubjectSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
    final courseRegistrationService = PersonalTimetableCalendarService(courseRegistrationRepository);
    useFuture(useMemoized(() => courseRegistrationService.getPersonalTimetableItems()));

    // TODO
    return const SizedBox.shrink();
  }
}
