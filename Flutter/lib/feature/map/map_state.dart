import 'package:dotto/domain/floor.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_state.freezed.dart';

@freezed
abstract class MapState with _$MapState {
  const factory MapState({
    required List<Room> rooms,
    required List<Room> filteredRooms,
    required DateTime searchDatetime,
    required Floor selectedFloor,
    required TransformationController transformationController,
    MapTileProps? focusedMapTileProps,
  }) = _MapState;
}
