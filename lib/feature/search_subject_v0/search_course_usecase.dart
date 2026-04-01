import 'package:dotto/domain/academic_area.dart';
import 'package:dotto/domain/grade.dart';

final class SearchCourseUsecase {
  factory SearchCourseUsecase() {
    return _instance;
  }
  SearchCourseUsecase._internal();
  static final SearchCourseUsecase _instance = SearchCourseUsecase._internal();

  Future<Grade?> getUserGrade() async {
    return null;
  }

  Future<AcademicArea?> getUserAcademicArea() async {
    return null;
  }
}
