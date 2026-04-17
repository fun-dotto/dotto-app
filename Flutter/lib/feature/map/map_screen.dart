import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dotto/controller/user_controller.dart';
import 'package:dotto/domain/map_tile_props.dart';
import 'package:dotto/feature/map/fun_map.dart';
import 'package:dotto/feature/map/map_viewmodel.dart';
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
    final asyncViewModel = ref.watch(mapViewModelProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new);
    final sheetController = useRef<PersistentBottomSheetController?>(null);
    final focusedMapTileProps = useState<MapTileProps?>(null);

    final searchDatetime = asyncViewModel.value?.searchDatetime;
    final rooms = asyncViewModel.value?.rooms;
    final selectedFloor = asyncViewModel.value?.selectedFloor;

    useEffect(() {
      focusedMapTileProps.value = null;
      return null;
    }, [selectedFloor]);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        sheetController.value?.close();
        sheetController.value = null;

        final props = focusedMapTileProps.value;
        if (props == null || rooms == null || searchDatetime == null) {
          return;
        }
        final room = rooms.firstWhereOrNull((e) => e.id == props.id);
        if (room == null) {
          return;
        }

        final newController = scaffoldKey.currentState?.showBottomSheet(
          (_) => SizedBox(
            height: 240,
            child: MapDetailBottomSheet(
              props: props,
              room: room,
              dateTime: searchDatetime,
              isAuthenticated: isAuthenticated,
              onDismissed: () {
                focusedMapTileProps.value = null;
              },
              onGoToSettingButtonTapped: onGoToSettingButtonTapped,
            ),
          ),
          showDragHandle: true,
        );
        sheetController.value = newController;
        final shownPropsId = props.id;
        unawaited(
          newController?.closed.then((_) {
                if (sheetController.value == newController) {
                  sheetController.value = null;
                }
                if (focusedMapTileProps.value?.id == shownPropsId) {
                  focusedMapTileProps.value = null;
                }
              }) ??
              Future<void>.value(),
        );
      });
      return null;
    }, [focusedMapTileProps.value?.id]);

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
              builder: (context, controller) {
                return SearchBar(
                  // controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (value) async {
                    controller.openView();
                    await ref
                        .read(mapViewModelProvider.notifier)
                        .onSearchTextChanged(value);
                  },
                  onSubmitted: (value) async {
                    await ref
                        .read(mapViewModelProvider.notifier)
                        .onSearchTextSubmitted(value);
                  },
                  leading: const Icon(Icons.search),
                  hintText: '部屋名、教員名、メールアドレスで検索',
                );
              },
              suggestionsBuilder: (context, controller) {
                switch (asyncViewModel) {
                  case AsyncData(:final value):
                    if (value.filteredRooms.isEmpty) {
                      return [const ListTile(title: Text('見つかりませんでした'))];
                    }
                    return value.filteredRooms.map((item) {
                      return ListTile(
                        title: Text(item.name),
                        onTap: () {
                          controller.closeView(item.name);
                          ref
                              .read(mapViewModelProvider.notifier)
                              .onSearchResultRowTapped(item);
                          focusedMapTileProps.value = FUNMap.tileProps
                              .firstWhereOrNull((e) => e.id == item.id);
                        },
                      );
                    }).toList();
                  case AsyncError(:final error):
                    return [ListTile(title: Text('エラーが発生しました: $error'))];
                  case AsyncLoading():
                    return [const ListTile(title: Text('読み込み中...'))];
                }
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: asyncViewModel.when(
          data: (viewModel) => Column(
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
                              selectedFloor: viewModel.selectedFloor,
                              onPressed: (floor) {
                                ref
                                    .read(mapViewModelProvider.notifier)
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
                                      viewModel.transformationController,
                                  selectedFloor: viewModel.selectedFloor,
                                  rooms: viewModel.rooms,
                                  focusedMapTileProps:
                                      focusedMapTileProps.value,
                                  dateTime: viewModel.searchDatetime,
                                  onTapped: (props, room) {
                                    viewModel.focusNode.unfocus();
                                    focusedMapTileProps.value =
                                        focusedMapTileProps.value == props
                                        ? null
                                        : props;
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
                          searchDatetime: viewModel.searchDatetime,
                          onPeriodButtonTapped: (dateTime) async {
                            var setDate = dateTime;
                            if (setDate.hour == 0) {
                              setDate = DateTime.now();
                            }
                            ref
                                .read(mapViewModelProvider.notifier)
                                .onPeriodButtonTapped(setDate);
                          },
                          onDatePickerConfirmed: (dateTime) async {
                            ref
                                .read(mapViewModelProvider.notifier)
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
