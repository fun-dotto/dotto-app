import 'dart:async';

import 'package:dotto/feature/announcement/announcement_action.dart';
import 'package:dotto/feature/announcement/announcement_effects.dart';
import 'package:dotto/feature/announcement/announcement_reducer.dart';
import 'package:dotto/feature/announcement/announcement_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef AnnouncementDispatch = void Function(AnnouncementAction);

class AnnouncementStore {
  const AnnouncementStore({
    required this.state,
    required this.dispatch,
    required this.refresh,
  });

  final AnnouncementState state;
  final AnnouncementDispatch dispatch;
  final Future<void> Function() refresh;
}

AnnouncementStore useAnnouncementStore(WidgetRef ref) {
  final store = useReducer<AnnouncementState, AnnouncementAction>(
    announcementReduce,
    initialState: AnnouncementState.initial(),
    initialAction: const AnnouncementAction.refreshRequested(),
  );
  final pendingRefresh = useRef<Completer<void>?>(null);

  useAnnouncementEffects(
    fetchEpoch: store.state.fetchEpoch,
    dispatch: store.dispatch,
    ref: ref,
    pendingRefresh: pendingRefresh,
  );

  Future<void> refresh() {
    final existing = pendingRefresh.value;
    if (existing != null && !existing.isCompleted) {
      return existing.future;
    }
    final completer = Completer<void>();
    pendingRefresh.value = completer;
    store.dispatch(const AnnouncementAction.refreshRequested());
    return completer.future;
  }

  return AnnouncementStore(
    state: store.state,
    dispatch: store.dispatch,
    refresh: refresh,
  );
}
