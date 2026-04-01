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
            SearchSubjectFilterSection(
              filter: currentFilter.value,
              onChanged: (value) => currentFilter.value = value,
              onClear: () => currentFilter.value = SubjectFilter(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchSubjectFilterSection extends HookWidget {
  const SearchSubjectFilterSection({super.key, required this.filter, required this.onChanged, this.onClear});

  final SubjectFilter filter;
  final ValueChanged<SubjectFilter> onChanged;
  final VoidCallback? onClear;
  static const _availableGrades = [Grade.b1, Grade.b2, Grade.b3, Grade.b4, Grade.m1, Grade.m2];

  @override
  Widget build(BuildContext context) {
    final hasCulturalClassification = filter.classifications.contains(SubjectClassification.cultural);
    final isBasicAttributesExpanded = useState(false);
    final isOtherAttributesExpanded = useState(false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onClear != null) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: filter.hasActiveFilters ? onClear : null, child: const Text('条件をクリア')),
          ),
          const SizedBox(height: 4),
        ],
        _buildCollapsibleSection(
          context: context,
          label: '開講時期・必修/選択・分類・教養区分',
          isExpanded: isOtherAttributesExpanded.value,
          onExpandedChanged: (value) => isOtherAttributesExpanded.value = value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChipGroup<Semester>(
                context: context,
                label: '開講時期',
                values: Semester.values,
                selected: filter.semesters,
                onChanged: (v) => onChanged(filter.copyWith(semesters: v)),
                labelBuilder: (v) => v.label,
              ),
              const SizedBox(height: 12),
              _buildFilterChipGroup<SubjectRequirementType>(
                context: context,
                label: '必修/選択',
                values: SubjectRequirementType.values,
                selected: filter.requirements,
                onChanged: (v) => onChanged(filter.copyWith(requirements: v)),
                labelBuilder: (v) => v.label,
              ),
              const SizedBox(height: 12),
              _buildFilterChipGroup<SubjectClassification>(
                context: context,
                label: '分類',
                values: SubjectClassification.values,
                selected: filter.classifications,
                onChanged: (v) {
                  final hasCultural = v.contains(SubjectClassification.cultural);
                  onChanged(
                    filter.copyWith(
                      classifications: v,
                      culturalSubjectCategories: hasCultural ? filter.culturalSubjectCategories : [],
                    ),
                  );
                },
                labelBuilder: (v) => v.label,
              ),
              if (hasCulturalClassification) ...[
                const SizedBox(height: 12),
                _buildFilterChipGroup<CulturalSubjectCategory>(
                  context: context,
                  label: '教養区分',
                  values: CulturalSubjectCategory.values,
                  selected: filter.culturalSubjectCategories,
                  onChanged: (v) => onChanged(filter.copyWith(culturalSubjectCategories: v)),
                  labelBuilder: (v) => v.label,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCollapsibleSection(
          context: context,
          label: 'コース/領域・学年・クラス',
          isExpanded: isBasicAttributesExpanded.value,
          onExpandedChanged: (value) => isBasicAttributesExpanded.value = value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilterChipGroup<AcademicArea>(
                context: context,
                label: 'コース/領域',
                values: AcademicArea.values,
                selected: filter.courses,
                onChanged: (v) => onChanged(filter.copyWith(courses: v)),
                labelBuilder: (v) => v.label,
              ),
              const SizedBox(height: 12),
              _buildFilterChipGroup<Grade>(
                context: context,
                label: '学年',
                values: _availableGrades,
                selected: filter.grades,
                onChanged: (v) => onChanged(filter.copyWith(grades: v)),
                labelBuilder: (v) => v.label,
              ),
              const SizedBox(height: 12),
              _buildFilterChipGroup<AcademicClass>(
                context: context,
                label: 'クラス',
                values: AcademicClass.values,
                selected: filter.classes,
                onChanged: (v) => onChanged(filter.copyWith(classes: v)),
                labelBuilder: (v) => v.label,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleSection({
    required BuildContext context,
    required String label,
    required bool isExpanded,
    required ValueChanged<bool> onExpandedChanged,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onExpandedChanged(!isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(label, style: Theme.of(context).textTheme.labelLarge)),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        if (isExpanded) child,
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        _buildFilterChipRow<T>(
          context: context,
          values: values,
          selected: selected,
          onChanged: onChanged,
          labelBuilder: labelBuilder,
        ),
      ],
    );
  }

  Widget _buildFilterChipRow<T>({
    required BuildContext context,
    required List<T> values,
    required List<T> selected,
    required ValueChanged<List<T>> onChanged,
    required String Function(T) labelBuilder,
  }) {
    final colors = Theme.of(context).semanticColors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            () {
              final value = values[i];
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
            }(),
          ],
        ],
      ),
    );
  }
}
