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
    final basicFilterCount = filter.courses.length + filter.grades.length + filter.classes.length;
    final otherFilterCount =
        filter.semesters.length +
        filter.requirements.length +
        filter.classifications.length +
        filter.culturalSubjectCategories.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (onClear != null) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: filter.hasActiveFilters ? onClear : null, child: const Text('条件をクリア')),
          ),
        ],
        _buildCollapsibleSection(
          context: context,
          label: '開講時期・必修/選択・分類・教養区分',
          isExpanded: isOtherAttributesExpanded.value,
          onExpandedChanged: (value) => isOtherAttributesExpanded.value = value,
          badgeCount: otherFilterCount,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              _buildFilterChipGroup<Semester>(
                context: context,
                label: '開講時期',
                values: Semester.values,
                selected: filter.semesters,
                onChanged: (v) => onChanged(filter.copyWith(semesters: v)),
                labelBuilder: (v) => v.label,
              ),
              _buildFilterChipGroup<SubjectRequirementType>(
                context: context,
                label: '必修/選択',
                values: SubjectRequirementType.values,
                selected: filter.requirements,
                onChanged: (v) => onChanged(filter.copyWith(requirements: v)),
                labelBuilder: (v) => v.label,
              ),
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
              if (hasCulturalClassification)
                _buildFilterChipGroup<CulturalSubjectCategory>(
                  context: context,
                  label: '教養区分',
                  values: CulturalSubjectCategory.values,
                  selected: filter.culturalSubjectCategories,
                  onChanged: (v) => onChanged(filter.copyWith(culturalSubjectCategories: v)),
                  labelBuilder: (v) => v.label,
                ),
            ],
          ),
        ),
        const Divider(height: 0),
        _buildCollapsibleSection(
          context: context,
          label: 'コース/領域・学年・クラス',
          isExpanded: isBasicAttributesExpanded.value,
          onExpandedChanged: (value) => isBasicAttributesExpanded.value = value,
          badgeCount: basicFilterCount,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              _buildFilterChipGroup<AcademicArea>(
                context: context,
                label: 'コース/領域',
                values: AcademicArea.values,
                selected: filter.courses,
                onChanged: (v) => onChanged(filter.copyWith(courses: v)),
                labelBuilder: (v) => v.label,
              ),
              _buildFilterChipGroup<Grade>(
                context: context,
                label: '学年',
                values: _availableGrades,
                selected: filter.grades,
                onChanged: (v) => onChanged(filter.copyWith(grades: v)),
                labelBuilder: (v) => v.label,
              ),
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
    int badgeCount = 0,
  }) {
    final colors = Theme.of(context).semanticColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => onExpandedChanged(!isExpanded),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              spacing: 8,
              children: [
                Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
                if (badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: colors.accentPrimary, borderRadius: BorderRadius.circular(999)),
                    child: Text(
                      '$badgeCount',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colors.labelTertiary),
                    ),
                  ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          tween: Tween<double>(begin: 0, end: isExpanded ? 1 : 0),
          child: Padding(padding: const EdgeInsets.only(top: 12), child: child),
          builder: (context, value, child) {
            return ClipRect(
              child: Align(alignment: Alignment.topCenter, heightFactor: value, child: child),
            );
          },
        ),
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
      spacing: 4,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
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
        spacing: 8,
        children: [
          for (final value in values)
            () {
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
      ),
    );
  }
}
