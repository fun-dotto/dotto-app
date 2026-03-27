import 'package:built_collection/built_collection.dart';
import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/domain/timetable_item.dart';
import 'package:dotto/feature/subject/search_subject_filter_screen.dart';
import 'package:dotto/feature/subject/subject_detail_screen.dart';
import 'package:dotto/repository/course_registration_repository.dart';
import 'package:dotto/repository/subject_repository.dart';
import 'package:dotto/repository/timetable_repository.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchSubjectScreen extends HookConsumerWidget {
  const SearchSubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final courseRegistrationRepository = CourseRegistrationRepositoryImpl(apiClient);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final timetableRepository = TimetableRepositoryImpl(apiClient);
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final filter = useState(SubjectFilter());
    final subjects = useState<AsyncValue<List<SubjectSummary>>>(const AsyncData([]));
    final cachedTimetableItems = useState<List<TimetableItem>?>(null);

    Future<void> search() async {
      subjects
        ..value = const AsyncLoading()
        ..value = await AsyncValue.guard(() async {
          var timetableItems = cachedTimetableItems.value;
          if (timetableItems == null) {
            timetableItems = await timetableRepository.getTimetableItems(Semester.values);
            cachedTimetableItems.value = timetableItems;
          }
          final courseRegistrationsFuture = courseRegistrationRepository.getCourseRegistrations(Semester.values);
          final subjectsFuture = subjectRepository.getSubjects(textEditingController.text, filter.value);
          final courseRegistrations = await courseRegistrationsFuture;
          final subjects = await subjectsFuture;
          final registeredSubjectIds = courseRegistrations.map((e) => e.subject.id).toSet();
          final timetableSlotsBySubjectId = {
            for (final item in timetableItems)
              if (item.subject.slot != null) item.subject.id: item.subject.slot,
          };
          final newSubjects = BuiltList<SubjectSummary>(
            subjects.map((subject) {
              return subject.copyWith(
                slot: timetableSlotsBySubjectId[subject.id],
                isAddedToTimetable: registeredSubjectIds.contains(subject.id),
              );
            }),
          );
          return newSubjects.toList();
        });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('科目検索'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await showModalBottomSheet<SubjectFilter>(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (_) => SearchSubjectFilterScreen(filter: filter.value),
              );
              if (result != null) {
                filter.value = result;
                if (result.hasActiveFilters) {
                  await search();
                }
              }
            },
            icon: Badge(isLabelVisible: filter.value.hasActiveFilters, child: const Icon(Icons.tune)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 8,
          children: [
            DottoTextField(
              placeholder: '科目名で検索',
              controller: textEditingController,
              focusNode: focusNode,
              onSubmitted: (_) => search(),
            ),
            Expanded(
              child: switch (subjects.value) {
                AsyncData(:final value) =>
                  value.isEmpty && filter.value.hasActiveFilters
                      ? const Center(child: Text('科目が見つかりませんでした'))
                      : ListView.separated(
                          separatorBuilder: (_, _) => const Divider(height: 0),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final subject = value[index];
                            return ListTile(
                              title: Text(subject.name),
                              subtitle: () {
                                final slot = subject.slot;
                                if (slot == null) return null;
                                return Text('${slot.dayOfWeek.label}${slot.period.number}');
                              }(),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (context) => SubjectDetailScreen(id: subject.id)),
                                );
                              },
                              trailing: const Icon(Icons.chevron_right),
                              leading: () {
                                final isAddedToTimetable = subject.isAddedToTimetable;
                                if (isAddedToTimetable == null) return null;
                                return Icon(isAddedToTimetable ? Icons.check : Icons.add);
                              }(),
                            );
                          },
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        ),
                AsyncError() => const Center(child: Text('科目の検索に失敗しました。')),
                AsyncLoading() => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}
