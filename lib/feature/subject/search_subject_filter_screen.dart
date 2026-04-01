import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/academic_class.dart';
import 'package:dotto/domain/cultural_subject_category.dart';
import 'package:dotto/domain/grade.dart';
import 'package:dotto/domain/semester.dart';
import 'package:dotto/domain/subject_classification.dart';
import 'package:dotto/domain/subject_filter.dart';
import 'package:dotto/domain/subject_requirement_type.dart';
import 'package:dotto_design_system/style/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SearchSubjectFilterScreen extends HookWidget {
  const SearchSubjectFilterScreen({super.key, required this.filter});

  final SubjectFilter filter;
  static const _availableGrades = [Grade.b1, Grade.b2, Grade.b3, Grade.b4, Grade.m1, Grade.m2];

  @override
  Widget build(BuildContext context) {
    final currentFilter = useState(filter);
    final hasCulturalClassification = currentFilter.value.classifications.contains(SubjectClassification.cultural);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.of(context).pop(currentFilter.value);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('検索条件'),
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(currentFilter.value),
            icon: const Icon(Icons.close),
          ),
          actions: [
            TextButton(
              onPressed: currentFilter.value.hasActiveFilters ? () => currentFilter.value = SubjectFilter() : null,
              child: const Text('条件をクリア'),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _buildFilterChipGroup<Grade>(
              context: context,
              label: '学年',
              values: _availableGrades,
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
              onChanged: (v) {
                final hasCultural = v.contains(SubjectClassification.cultural);
                currentFilter.value = currentFilter.value.copyWith(
                  classifications: v,
                  culturalSubjectCategories: hasCultural ? currentFilter.value.culturalSubjectCategories : [],
                );
              },
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
            _buildFilterChipGroup<SubjectRequirementType>(
              context: context,
              label: '必修・選択',
              values: SubjectRequirementType.values,
              selected: currentFilter.value.requirements,
              onChanged: (v) => currentFilter.value = currentFilter.value.copyWith(requirements: v),
              labelBuilder: (v) => v.label,
            ),
            if (hasCulturalClassification) ...[
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
