import 'package:dotto/api/api_client.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/subject/search_subject_filter_screen.dart';
import 'package:dotto/feature/subject/subject_detail_screen.dart';
import 'package:dotto/feature/subject/subject_repository.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchSubjectScreen extends HookConsumerWidget {
  const SearchSubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiClient = ref.read(apiClientProvider);
    final subjectRepository = SubjectRepositoryImpl(apiClient);
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final filter = useState(SubjectFilter());
    final subjects = useState<AsyncValue<List<SubjectSummary>>>(const AsyncData([]));

    bool isEmptyFilter() =>
        textEditingController.text.isEmpty &&
        filter.value.grades.isEmpty &&
        filter.value.courses.isEmpty &&
        filter.value.classes.isEmpty &&
        filter.value.classifications.isEmpty &&
        filter.value.semesters.isEmpty &&
        filter.value.requirements.isEmpty &&
        filter.value.culturalSubjectCategories.isEmpty;

    Future<void> search() async {
      subjects
        ..value = const AsyncLoading()
        ..value = await AsyncValue.guard(() => subjectRepository.getSubjects(textEditingController.text, filter.value));
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
              }
              await search();
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
                  value.isEmpty && !isEmptyFilter()
                      ? const Center(child: Text('科目が見つかりませんでした'))
                      : ListView.separated(
                          separatorBuilder: (_, _) => const Divider(height: 0),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final subject = value[index];
                            return ListTile(
                              title: Text(subject.name),
                              subtitle: Text('${subject.dayOfWeek.label}${subject.period.number}'),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(builder: (context) => SubjectDetailScreen(id: subject.id)),
                                );
                              },
                              trailing: const Icon(Icons.chevron_right),
                              leading: Icon(subject.isAddedToTimetable ? Icons.check : Icons.add),
                            );
                          },
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        ),
                AsyncError(:final error) => Center(child: Text('エラーが発生しました: $error')),
                AsyncLoading() => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }
}
