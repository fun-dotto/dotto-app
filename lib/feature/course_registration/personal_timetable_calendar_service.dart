import 'package:dotto/domain/personal_timetable_item.dart';
import 'package:dotto/feature/course_registration/course_registration_repository.dart';

final class PersonalTimetableCalendarService {
  PersonalTimetableCalendarService(this.courseRegistrationRepository);

  final CourseRegistrationRepository courseRegistrationRepository;

  Future<List<PersonalTimetableItem>> getPersonalTimetableItems() async {
    // TODO
    return [];
  }
}
