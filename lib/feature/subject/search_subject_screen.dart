import 'package:dotto/domain/subject_faculty.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/feature/subject/search_subject_filter_screen.dart';
import 'package:dotto/feature/subject/search_subject_reducer.dart';
import 'package:dotto/feature/subject/subject_detail_screen.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchSubjectScreen extends HookConsumerWidget {
  const SearchSubjectScreen({super.key});

  String? _buildFacultyLabel(List<SubjectFaculty> faculties) {
    if (faculties.isEmpty) {
      return null;
    }

    final primaryNames = faculties
        .where((faculty) => faculty.isPrimary)
        .map((faculty) => faculty.faculty.name)
        .toList();
    if (primaryNames.isNotEmpty) {
      final otherCount = faculties.length - primaryNames.length;
      return otherCount > 0 ? '${primaryNames.join(', ')} 他$otherCount名' : primaryNames.join(', ');
    }

    final fallbackNames = faculties.map((faculty) => faculty.faculty.name).toList();
    final otherCount = fallbackNames.length - 1;
    return otherCount > 0 ? '${fallbackNames.first} 他$otherCount名' : fallbackNames.first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final filter = useState(SubjectFilter());
    final processingSubjectIds = useState(<String>{});
    final subjects = ref.watch(searchSubjectReducerProvider);

    Future<void> search() async {
      await ref
          .read(searchSubjectReducerProvider.notifier)
          .search(query: textEditingController.text, filter: filter.value);
    }

    Future<void> toggleCourseRegistration({required String subjectId, required bool isAddedToTimetable}) async {
      final processing = processingSubjectIds.value;
      if (processing.contains(subjectId)) {
        return;
      }
      processingSubjectIds.value = {...processing, subjectId};
      try {
        final notifier = ref.read(searchSubjectReducerProvider.notifier);
        if (isAddedToTimetable) {
          await notifier.unregisterSubject(subjectId);
        } else {
          await notifier.registerSubject(subjectId);
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('履修登録の更新に失敗しました')));
        }
      } finally {
        processingSubjectIds.value = {...processingSubjectIds.value.where((id) => id != subjectId)};
      }
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
              child: switch (subjects) {
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
                                final lines = <String>[];
                                final slots = subject.slots;
                                if (slots != null && slots.isNotEmpty) {
                                  lines.add(
                                    slots.map((slot) => '${slot.dayOfWeek.label}${slot.period.number}').join(' / '),
                                  );
                                }
                                final facultyLabel = _buildFacultyLabel(subject.faculties);
                                if (facultyLabel != null) {
                                  lines.add(facultyLabel);
                                }
                                if (lines.isEmpty) {
                                  return null;
                                }
                                return Text(lines.join('\n'));
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
                                final isProcessing = processingSubjectIds.value.contains(subject.id);
                                return IconButton(
                                  onPressed: isProcessing
                                      ? null
                                      : () => toggleCourseRegistration(
                                          subjectId: subject.id,
                                          isAddedToTimetable: isAddedToTimetable,
                                        ),
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 220),
                                    switchInCurve: Curves.easeOutBack,
                                    switchOutCurve: Curves.easeIn,
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(scale: animation, child: child),
                                      );
                                    },
                                    child: isProcessing
                                        ? const SizedBox(
                                            key: ValueKey('loading'),
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : Icon(
                                            isAddedToTimetable ? Icons.check : Icons.add,
                                            key: ValueKey(isAddedToTimetable ? 'registered' : 'unregistered'),
                                          ),
                                  ),
                                  tooltip: isAddedToTimetable ? '履修解除' : '履修登録',
                                );
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
