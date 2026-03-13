import 'package:dotto/domain/subject_summary.dart';
import 'package:dotto/feature/search_subject/domain/subject_filter.dart';
import 'package:dotto/feature/search_subject/search_subject_filter_screen.dart';
import 'package:dotto_design_system/component/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchSubjectScreen extends HookConsumerWidget {
  const SearchSubjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    final subjects = useState<List<SubjectSummary>>([]);
    final filter = useState(SubjectFilter());

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
            DottoTextField(placeholder: '科目名で検索', controller: textEditingController, focusNode: focusNode),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, _) => const Divider(height: 0),
                itemCount: subjects.value.length,
                itemBuilder: (context, index) {
                  final subject = subjects.value[index];
                  return ListTile(
                    title: Text(subject.name),
                    subtitle: Text('${subject.dayOfWeek.label}${subject.period.number}'),
                    onTap: () {},
                    trailing: const Icon(Icons.chevron_right),
                    leading: Icon(subject.isAddedToTimetable ? Icons.check : Icons.add),
                  );
                },
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
