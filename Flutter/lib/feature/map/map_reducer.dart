import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:dotto/feature/map/fun_map.dart';
import 'package:dotto/feature/map/map_state.dart';
import 'package:dotto/repository/repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_reducer.g.dart';

@riverpod
final class MapReducer extends _$MapReducer {
  @override
  Future<MapState> build() async {
    final rooms = await ref.read(roomRepositoryProvider).getRooms();
    return MapState(
      rooms: rooms,
      filteredRooms: [],
      searchDatetime: DateTime.now(),
      selectedFloor: Floor.third,
      transformationController: TransformationController(Matrix4.identity()),
    );
  }

  void onFloorButtonTapped(Floor floor) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(selectedFloor: floor, focusedMapTileProps: null),
    );
    current.transformationController.value = Matrix4.identity();
  }

  Future<void> onSearchTextChanged(String query) async {
    final filteredRooms = await _search(query);
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(filteredRooms: filteredRooms));
  }

  Future<void> onSearchTextSubmitted(String query) async {
    final filteredRooms = await _search(query);
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(filteredRooms: filteredRooms));
  }

  void onSearchTextCleared() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(filteredRooms: const []));
  }

  Future<List<Room>> _search(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final current = state.asData?.value;
    return (current?.rooms ?? [])
        .where(
          (room) =>
              room.id.toLowerCase().contains(query.toLowerCase()) ||
              room.name.toLowerCase().contains(query.toLowerCase()) ||
              room.description.toLowerCase().contains(query.toLowerCase()) ||
              room.email.toLowerCase().contains(query.toLowerCase()) ||
              room.keywords.any(
                (keyword) =>
                    keyword.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

  void onSearchResultRowTapped(Room room) {
    final current = state.asData?.value;
    if (current == null) return;
    final tileProps = ref
        .read(funMapProvider)
        .firstWhereOrNull((e) => e.id == room.id);
    state = AsyncData(
      current.copyWith(
        selectedFloor: room.floor,
        focusedMapTileProps: tileProps,
      ),
    );
  }

  void onMapTileTapped(MapTileProps props) {
    final current = state.asData?.value;
    if (current == null) return;
    final next = current.focusedMapTileProps == props ? null : props;
    state = AsyncData(current.copyWith(focusedMapTileProps: next));
  }

  void onBottomSheetDismissed() {
    final current = state.asData?.value;
    if (current == null || current.focusedMapTileProps == null) return;
    state = AsyncData(current.copyWith(focusedMapTileProps: null));
  }

  void onPeriodButtonTapped(DateTime dateTime) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(searchDatetime: dateTime));
  }

  void onDatePickerConfirmed(DateTime dateTime) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(searchDatetime: dateTime));
  }
}
