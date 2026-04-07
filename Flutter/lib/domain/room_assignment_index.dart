import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/period.dart';

final class RoomAssignmentIndex {
  RoomAssignmentIndex({
    required this.roomNamesBySlotAndTitle,
    required this.roomNamesByTitle,
  });

  final Map<({DayOfWeek dayOfWeek, Period period, String title}), String>
  roomNamesBySlotAndTitle;
  final Map<String, String> roomNamesByTitle;

  String? roomName({
    required DayOfWeek dayOfWeek,
    required Period period,
    required String title,
  }) {
    return roomNamesBySlotAndTitle[(
          dayOfWeek: dayOfWeek,
          period: period,
          title: title,
        )] ??
        roomNamesByTitle[title];
  }

  String? roomNameByTitle(String title) {
    return roomNamesByTitle[title];
  }
}
