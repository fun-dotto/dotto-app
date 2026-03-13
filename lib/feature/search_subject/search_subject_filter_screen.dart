import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/cultural_subject_category.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_classification.dart';
import 'package:dotto/domain/subject_requirement.dart';
import 'package:dotto/feature/search_subject/domain/subject_filter.dart';
import 'package:dotto_design_system/style/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchSubjectFilterScreen extends HookWidget {
  const SearchSubjectFilterScreen({super.key, required this.filter});

  final SubjectFilter filter;

  @override
  Widget build(BuildContext context) {
    final currentFilter = useState(filter);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).pop(currentFilter.value);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('フィルター'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(currentFilter.value),
            icon: const Icon(Icons.close),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildFilterChipGroup<Grade>(
              context: context,
              label: '学年',
              values: Grade.values,
              selected: currentFilter.value.grades,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(grades: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<AcademicArea>(
              context: context,
              label: 'コース・領域',
              values: AcademicArea.values,
              selected: currentFilter.value.courses,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(courses: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<AcademicClass>(
              context: context,
              label: 'クラス',
              values: AcademicClass.values,
              selected: currentFilter.value.classes,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(classes: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<SubjectClassification>(
              context: context,
              label: '分類',
              values: SubjectClassification.values,
              selected: currentFilter.value.classifications,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(classifications: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<Semester>(
              context: context,
              label: '開講時期',
              values: Semester.values,
              selected: currentFilter.value.semesters,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(semesters: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<SubjectRequirement>(
              context: context,
              label: '必修・選択',
              values: SubjectRequirement.values,
              selected: currentFilter.value.requirements,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(requirements: v),
              labelBuilder: (v) => v.label,
            ),
            const SizedBox(height: 12),
            _buildFilterChipGroup<CulturalSubjectCategory>(
              context: context,
              label: '教養区分',
              values: CulturalSubjectCategory.values,
              selected: currentFilter.value.culturalSubjectCategories,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(culturalSubjectCategories: v),
              labelBuilder: (v) => v.label,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChipGroup<T>({
    required BuildContext context,
    required String label,
    required List<T> values,
    required List<T> selected,
    required ValueChanged<List<T>> onChanged,
    required String Function(T) labelBuilder,
  }) {
    final colors = Theme.of(context).semanticColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: values.map((value) {
            final isSelected = selected.contains(value);
            return FilterChip(
              label: Text(labelBuilder(value)),
              selected: isSelected,
              onSelected: (bool newValue) {
                if (newValue) {
                  onChanged([...selected, value]);
                } else {
                  onChanged(selected.where((v) => v != value).toList());
                }
              },
              showCheckmark: false,
              selectedColor: colors.accentPrimary.withValues(alpha: 0.2),
              side: BorderSide(color: isSelected ? colors.accentPrimary : colors.borderPrimary),
            );
          }).toList(),
        ),
      ],
    );
  }
}
