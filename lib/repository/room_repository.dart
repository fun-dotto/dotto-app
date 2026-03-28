import 'package:dotto/api/firebase/room_api.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomRepositoryProvider = Provider<RoomRepository>(RoomRepositoryImpl.new);

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<RoomAssignmentIndex> getRoomAssignmentIndex();
}

final class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl(this.ref);

  final Ref ref;

  @override
  Future<List<Room>> getRooms() async {
    final roomResponses = await RoomAPI.getRooms();
    final roomScheduleResponses = await RoomAPI.getRoomSchedules();

    return roomResponses.entries.expand((floorEntry) {
      final floorLabel = floorEntry.key;
      final roomsMap = floorEntry.value;
      final floor = Floor.fromLabel(floorLabel);

      return roomsMap.entries.map((roomEntry) {
        final roomResponse = roomEntry.value;

        final schedules = (roomScheduleResponses[roomEntry.key] ?? [])
            .map(
              (scheduleResponse) => RoomSchedule(
                beginDatetime: scheduleResponse.beginDatetime,
                endDatetime: scheduleResponse.endDatetime,
                title: scheduleResponse.title,
              ),
            )
            .toList();

        return Room(
          id: roomResponse.classroomNo ?? roomEntry.key,
          name: roomResponse.header,
          shortName: roomEntry.key,
          description: roomResponse.detail ?? '',
          floor: floor,
          email: roomResponse.mail ?? '',
          keywords: roomResponse.searchWordList ?? [],
          schedules: schedules,
        );
      });
    }).toList();
  }

  @override
  Future<RoomAssignmentIndex> getRoomAssignmentIndex() async {
    final rooms = await getRooms();
    final roomNamesBySlotAndTitle = <({DayOfWeek dayOfWeek, Period period, String title}), Set<String>>{};
    final roomNamesByTitle = <String, Set<String>>{};

    for (final room in rooms) {
      final roomName = room.shortName.trim();
      if (roomName.isEmpty) {
        continue;
      }

      for (final schedule in room.schedules) {
        final title = schedule.title.trim();
        if (title.isEmpty) {
          continue;
        }

        final period = _periodFromSchedule(schedule);
        if (period == null) {
          continue;
        }

        final key = (dayOfWeek: DayOfWeek.fromDateTime(schedule.beginDatetime), period: period, title: title);
        roomNamesBySlotAndTitle.putIfAbsent(key, () => <String>{}).add(roomName);
        roomNamesByTitle.putIfAbsent(title, () => <String>{}).add(roomName);
      }
    }

    return RoomAssignmentIndex(
      roomNamesBySlotAndTitle: {for (final entry in roomNamesBySlotAndTitle.entries) entry.key: entry.value.join(', ')},
      roomNamesByTitle: {for (final entry in roomNamesByTitle.entries) entry.key: entry.value.join(', ')},
    );
  }

  Period? _periodFromSchedule(RoomSchedule schedule) {
    final beginMinutes = schedule.beginDatetime.hour * 60 + schedule.beginDatetime.minute;

    for (final period in Period.values) {
      final startMinutes = period.startTime.hour * 60 + period.startTime.minute;
      final endMinutes = period.endTime.hour * 60 + period.endTime.minute;
      if (beginMinutes >= startMinutes && beginMinutes <= endMinutes) {
        return period;
      }
    }
    return null;
  }
}

final class RoomAssignmentIndex {
  RoomAssignmentIndex({required this.roomNamesBySlotAndTitle, required this.roomNamesByTitle});

  final Map<({DayOfWeek dayOfWeek, Period period, String title}), String> roomNamesBySlotAndTitle;
  final Map<String, String> roomNamesByTitle;

  String? roomName({required DayOfWeek dayOfWeek, required Period period, required String title}) {
    return roomNamesBySlotAndTitle[(dayOfWeek: dayOfWeek, period: period, title: title)] ?? roomNamesByTitle[title];
  }

  String? roomNameByTitle(String title) {
    return roomNamesByTitle[title];
  }
}
