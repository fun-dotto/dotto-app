import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/feature/map/map_reducer.dart';
import 'package:dotto/feature/map/widget/map.dart';
import 'package:dotto/feature/map/widget/map_date_picker.dart';
import 'package:dotto/feature/map/widget/map_detail_bottom_sheet.dart';
import 'package:dotto/feature/map/widget/map_floor_button.dart';
import 'package:dotto/feature/map/widget/map_legend.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final class MapScreen extends HookConsumerWidget {
  const MapScreen({required this.onGoToSettingButtonTapped, super.key});

  final void Function() onGoToSettingButtonTapped;

  Widget _datePickerSection({
    required bool isAuthenticated,
    required DateTime searchDatetime,
    required void Function(DateTime) onPeriodButtonTapped,
    required void Function(DateTime) onDatePickerConfirmed,
  }) {
    if (!isAuthenticated) {
      return const SizedBox.shrink();
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MapDatePicker(
          searchDatetime: searchDatetime,
          onPeriodButtonTapped: onPeriodButtonTapped,
          onDatePickerConfirmed: onDatePickerConfirmed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(mapReducerProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new);
    final sheetController = useRef<PersistentBottomSheetController?>(null);
    final searchController = useMemoized(SearchController.new);
    useEffect(() {
      return () {
        sheetController.value?.close();
        searchController.dispose();
      };
    }, [searchController]);
    final searchFocusNode = useFocusNode();

    final searchDatetime = asyncState.value?.searchDatetime;
    final rooms = asyncState.value?.rooms;
    final focusedMapTileProps = asyncState.value?.focusedMapTileProps;

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        sheetController.value?.close();
        sheetController.value = null;
        searchFocusNode.unfocus();

        final props = focusedMapTileProps;
        if (props == null || rooms == null || searchDatetime == null) {
          return;
        }
        final room = rooms.firstWhereOrNull((e) => e.id == props.id);
        if (room == null) {
          return;
        }

        final sheetHeight = props is FacultyRoomMapTileProps ? 120.0 : 240.0;
        final newController = scaffoldKey.currentState?.showBottomSheet(
          (_) => SizedBox(
            height: sheetHeight,
            child: MapDetailBottomSheet(
              props: props,
              room: room,
              dateTime: searchDatetime,
              isAuthenticated: isAuthenticated,
              onGoToSettingButtonTapped: onGoToSettingButtonTapped,
            ),
          ),
          showDragHandle: true,
        );
        sheetController.value = newController;
        searchFocusNode.unfocus();
        final shownPropsId = props.id;
        unawaited(
          newController?.closed.then((_) {
                if (!context.mounted) return;
                if (sheetController.value == newController) {
                  sheetController.value = null;
                }
                final current = ref
                    .read(mapReducerProvider)
                    .value
                    ?.focusedMapTileProps;
                if (current?.id == shownPropsId) {
                  ref
                      .read(mapReducerProvider.notifier)
                      .onBottomSheetDismissed();
                }
              }) ??
              Future<void>.value(),
        );
      });
      return null;
    }, [focusedMapTileProps?.id, searchDatetime, isAuthenticated]);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'マップ',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: SemanticColor.light.accentPrimary,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchAnchor(
              searchController: searchController,
              textCapitalization: TextCapitalization.none,
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  focusNode: searchFocusNode,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16),
                  ),
                  textCapitalization: TextCapitalization.none,
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (value) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  hintText: '部屋名、教員名、メールアドレスで検索',
                );
              },
              suggestionsBuilder: (context, controller) {
                switch (asyncState) {
                  case AsyncData(:final value):
                    final query = controller.text.trim().toLowerCase();
                    if (query.isEmpty) {
                      return const <Widget>[];
                    }
                    final results = value.rooms
                        .where(
                          (room) =>
                              room.id.toLowerCase().contains(query) ||
                              room.name.toLowerCase().contains(query) ||
                              room.description.toLowerCase().contains(query) ||
                              room.email.toLowerCase().contains(query) ||
                              room.keywords.any(
                                (keyword) =>
                                    keyword.toLowerCase().contains(query),
                              ),
                        )
                        .toList();
                    if (results.isEmpty) {
                      return [const ListTile(title: Text('見つかりませんでした'))];
                    }
                    return results.map((item) {
                      return ListTile(
                        title: Text(item.name),
                        onTap: () {
                          controller.closeView(controller.text);
                          searchFocusNode.unfocus();
                          ref
                              .read(mapReducerProvider.notifier)
                              .onSearchResultRowTapped(item);
                        },
                      );
                    }).toList();
                  case AsyncError(:final error, :final stackTrace):
                    debugPrint(
                      'Failed to build map search suggestions: '
                      '$error\n$stackTrace',
                    );
                    return [const ListTile(title: Text('検索結果の取得に失敗しました'))];
                  case AsyncLoading():
                    return [const ListTile(title: Text('読み込み中...'))];
                }
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: asyncState.when(
          data: (state) => Column(
            spacing: 8,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      spacing: 8,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MapFloorButton(
                              selectedFloor: state.selectedFloor,
                              onPressed: (floor) {
                                ref
                                    .read(mapReducerProvider.notifier)
                                    .onFloorButtonTapped(floor);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              SizedBox.expand(
                                child: Map(
                                  mapViewTransformationController:
                                      state.transformationController,
                                  selectedFloor: state.selectedFloor,
                                  rooms: state.rooms,
                                  focusedMapTileProps:
                                      state.focusedMapTileProps,
                                  dateTime: state.searchDatetime,
                                  onTapped: (props, _) {
                                    ref
                                        .read(mapReducerProvider.notifier)
                                        .onMapTileTapped(props);
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: MapLegend(),
                              ),
                            ],
                          ),
                        ),
                        _datePickerSection(
                          isAuthenticated: isAuthenticated,
                          searchDatetime: state.searchDatetime,
                          onPeriodButtonTapped: (dateTime) async {
                            var setDate = dateTime;
                            if (setDate.hour == 0) {
                              setDate = DateTime.now();
                            }
                            ref
                                .read(mapReducerProvider.notifier)
                                .onPeriodButtonTapped(setDate);
                          },
                          onDatePickerConfirmed: (dateTime) async {
                            ref
                                .read(mapReducerProvider.notifier)
                                .onDatePickerConfirmed(dateTime);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          error: (error, stackTrace) => const Center(child: Text('エラーが発生しました')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
