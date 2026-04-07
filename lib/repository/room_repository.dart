import 'package:dotto/api/firebase/room_api.dart';
import 'package:dotto/domain/day_of_week.dart';
import 'package:dotto/domain/domain_error.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/period.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/domain/room_assignment_index.dart';
import 'package:dotto/domain/room_schedule.dart';

abstract class RoomRepository {
  Future<List<Room>> getRooms();
  Future<RoomAssignmentIndex> getRoomAssignmentIndex();
}

final class RoomRepositoryImpl implements RoomRepository {
  RoomRepositoryImpl();

  @override
  Future<List<Room>> getRooms() async {
    try {
      final (roomResponses, roomScheduleResponses) = await (RoomAPI.getRooms(), RoomAPI.getRoomSchedules()).wait;

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
    } on DomainError {
      rethrow;
    } on Exception catch (e, stackTrace) {
      throw DomainError.fromException(e: e, stackTrace: stackTrace);
    }
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
      roomNamesBySlotAndTitle: {
        for (final entry in roomNamesBySlotAndTitle.entries) entry.key: (entry.value.toList()..sort()).join(', '),
      },
      roomNamesByTitle: {
        for (final entry in roomNamesByTitle.entries) entry.key: (entry.value.toList()..sort()).join(', '),
      },
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
