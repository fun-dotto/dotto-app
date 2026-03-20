import 'package:dotto/feature/search_subject_v0/domain/search_course_filter_option_choice.dart';
import 'package:dotto/feature/search_subject_v0/domain/search_course_filter_options.dart';
import 'package:dotto/feature/search_subject_v0/widget/search_course_filter_checkbox.dart';
import 'package:flutter/material.dart';

final class SearchCourseFilterSection extends StatelessWidget {
  const SearchCourseFilterSection({
    required this.visibilityStatus,
    required this.selectedChoicesMap,
    required this.onChanged,
    super.key,
  });

  final Set<SearchCourseFilterOptions> visibilityStatus;
  final Map<SearchCourseFilterOptions, List<SearchCourseFilterOptionChoice>> selectedChoicesMap;
  final void Function(SearchCourseFilterOptions, SearchCourseFilterOptionChoice, bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: SearchCourseFilterOptions.values.map((e) {
        if (e == SearchCourseFilterOptions.largeCategory) {
          return SearchCourseFilterCheckbox(
            filterOption: e,
            selectedChoices: selectedChoicesMap[e] ?? [],
            onChanged: (choice, isSelected) => onChanged(e, choice, isSelected),
          );
        }
        return Visibility(
          visible: visibilityStatus.contains(e),
          child: SearchCourseFilterCheckbox(
            filterOption: e,
            selectedChoices: selectedChoicesMap[e] ?? [],
            onChanged: (choice, isSelected) => onChanged(e, choice, isSelected),
          ),
        );
      }).toList(),
    );
  }
}
