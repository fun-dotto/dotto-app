---
name: flutter-hooks-reducer
description: Flutter で flutter_hooks の useReducer + Freezed sealed Action + Effect フックによる純粋Reducer設計の feature を生成・レビュー・移行する。Riverpod Notifier 上にメソッド束を生やした「名ばかりReducer」を発見したとき、新規feature を Reducer パターンで作るとき、または既存 Reducer を useReducer ベースに置き換えるときに使う。キーワード: flutter reducer, useReducer, hooks_riverpod, freezed sealed action, effect hook, pure reducer。
license: MIT
metadata:
  author: Kanta Oikawa
  version: "1.0"
---

dotto-app（Flutter）における **`useReducer` ベースの Reducer パターン** を生成・レビュー・移行するためのスキル。AGENTS.md の "Reducer 設計" 節の規約を実装で守らせる。

## いつ使うか

- 新しい feature を Hooks + Reducer + Repository で書き起こすとき
- 既存の `lib/feature/**/xxx_reducer.dart`（Riverpod Notifier 上のメソッド束＝名ばかりReducer）を `useReducer` ベースに移行するとき
- レビューで `reduce` 関数が純粋か、Action が sealed か、副作用が Effect 層に出ているかを点検するとき

## いつ使わないか

- 画面横断で共有が必要なグローバル状態（認証ユーザー、テーマ、機能フラグなど）の設計 — そちらは Riverpod Notifier をそのまま使う
- Repository / API / 永続化層の追加 — `riverpod_annotation` の Provider 流儀に従う

## ファイル構成（feature 単位）

```
lib/feature/<feature>/
  <feature>_state.dart      # Freezed State
  <feature>_action.dart     # Freezed sealed Action
  <feature>_reducer.dart    # 純粋関数 reduce
  <feature>_effects.dart    # useEffect ベースの Effect フック
  <feature>_store.dart      # use<Feature>Store() 合成フック
  <feature>_screen.dart     # HookConsumerWidget
```

命名:

- ファイル: `<feature>_state.dart` / `_action.dart` / `_reducer.dart` / `_effects.dart` / `_store.dart` / `_screen.dart`
- 型: `XxxState` / `XxxAction` / `XxxStore`
- 関数: `xxxReduce` / `useXxxStore` / `useXxxEffects`

## テンプレート

### 1. State

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature>_state.freezed.dart';

@freezed
class BusState with _$BusState {
  const factory BusState({
    required BusStop? selectedStop,
    required bool isWeekday,
    required AsyncValue<BusTimetable> timetable,
  }) = _BusState;

  factory BusState.initial() => const BusState(
        selectedStop: null,
        isWeekday: true,
        timetable: AsyncValue.loading(),
      );
}
```

- loading / data / error は `AsyncValue<T>` に統一（個別の `isLoading` / `error` フィールドを生やさない）

### 2. Action（必ず sealed）

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<feature>_action.freezed.dart';

@freezed
sealed class BusAction with _$BusAction {
  // User intents
  const factory BusAction.weekdayToggled() = _WeekdayToggled;
  const factory BusAction.busStopSelected(BusStop stop) = _BusStopSelected;

  // System results（Effect 層から dispatch）
  const factory BusAction.timetableLoaded(BusTimetable timetable) = _TimetableLoaded;
  const factory BusAction.timetableFailed(DomainError error) = _TimetableFailed;
}
```

- `sealed class` 必須（switch の exhaustive チェックを効かせる）
- User intent は過去分詞形（`Toggled` / `Selected` / `Submitted`）、System result は `Loaded` / `Failed` で揃える

### 3. Reducer（純粋関数）

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '<feature>_action.dart';
import '<feature>_state.dart';

BusState busReduce(BusState state, BusAction action) {
  return switch (action) {
    _WeekdayToggled() => state.copyWith(isWeekday: !state.isWeekday),
    _BusStopSelected(:final stop) => state.copyWith(
        selectedStop: stop,
        timetable: const AsyncValue.loading(),
      ),
    _TimetableLoaded(:final timetable) =>
      state.copyWith(timetable: AsyncValue.data(timetable)),
    _TimetableFailed(:final error) =>
      state.copyWith(timetable: AsyncValue.error(error, StackTrace.current)),
  };
}
```

#### 純粋性チェックリスト（reducer 内で禁止）

- [ ] `Future` / `async` / `await` が無いか
- [ ] Repository や `ref` を一切参照していないか
- [ ] `DateTime.now()` / `DateTime.timestamp()` / `Random()` が無いか（必要なら Action のフィールドに渡す）
- [ ] `print` / `debugPrint` / `Logger` が無いか
- [ ] `switch` で全ケースを扱い切っているか（`default` を書いていないか）
- [ ] `state.copyWith(...)` のみで遷移しているか（直接 mutation していないか）

### 4. Effects（副作用層）

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '<feature>_action.dart';
import '<feature>_state.dart';

void useBusEffects({
  required BusState state,
  required void Function(BusAction) dispatch,
  required WidgetRef ref,
}) {
  useEffect(() {
    final stop = state.selectedStop;
    if (stop == null) return null;

    var cancelled = false;
    Future<void>(() async {
      try {
        final timetable =
            await ref.read(busRepositoryProvider).fetchTimetable(stop);
        if (!cancelled) dispatch(BusAction.timetableLoaded(timetable));
      } on DomainError catch (e) {
        if (!cancelled) dispatch(BusAction.timetableFailed(e));
      }
    });
    return () => cancelled = true;
  }, [state.selectedStop]);
}
```

- `useEffect` のキーは「どの state 変化で再実行するか」を最小限のフィールドで明示
- クリーンアップ関数で `cancelled` フラグを立て、unmount 後の dispatch を抑止
- 独立した副作用は `useEffect` を **複数回** 書く（1つに詰めて条件分岐しない）
- Repository は `DomainError` に変換済みである前提（AGENTS.md "Repository が画面層に例外を伝播..." 参照）

### 5. Store フック

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '<feature>_action.dart';
import '<feature>_effects.dart';
import '<feature>_reducer.dart';
import '<feature>_state.dart';

typedef BusDispatch = void Function(BusAction);

class BusStore {
  const BusStore({required this.state, required this.dispatch});
  final BusState state;
  final BusDispatch dispatch;
}

BusStore useBusStore(WidgetRef ref) {
  final store = useReducer<BusState, BusAction>(
    busReduce,
    initialState: BusState.initial(),
    initialAction: null,
  );
  useBusEffects(state: store.state, dispatch: store.dispatch, ref: ref);
  return BusStore(state: store.state, dispatch: store.dispatch);
}
```

### 6. Screen

```dart
class BusScreen extends HookConsumerWidget {
  const BusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = useBusStore(ref);
    return Scaffold(
      body: Column(
        children: [
          Switch(
            value: store.state.isWeekday,
            onChanged: (_) => store.dispatch(const BusAction.weekdayToggled()),
          ),
          // ...
        ],
      ),
    );
  }
}
```

## 既存「名ばかりReducer」からの移行手順

対象: `@riverpod final class XxxReducer extends _$XxxReducer` で書かれた Reducer。

1. **Action を抽出**: 既存メソッド名から User intent Action を起こす（`toggleWeekday()` → `BusAction.weekdayToggled()`）。非同期メソッドは User intent + System result のペアに分解する。
2. **State を `<feature>_state.dart` に切り出し**: 既存 Freezed State をそのまま移し、`AsyncValue<T>` に揃える。
3. **`reduce` を切り出し**: 各メソッドの `state = state.copyWith(...)` 部分を `reduce` の case に移植する。Repository 呼び出しは持ち込まない。
4. **Effects を切り出し**: 元メソッドの非同期部分を `useEffect` に移し、結果を System result Action として dispatch するよう書き換える。
5. **`use<Feature>Store()` を作成し画面を書き換え**: 画面の `ref.watch(xxxReducerProvider)` を `useXxxStore(ref).state` に、`ref.read(xxxReducerProvider.notifier).foo()` を `store.dispatch(...)` に置き換える。
6. **Riverpod Notifier 削除**: 古い `xxx_reducer.dart` の `@riverpod` クラスと `.g.dart` を削除。`build_runner` を再実行。
7. **検証**: 後述の検証手順を実行。

## 検証手順

ユーザーメモリの規約に従う:

- `eval "$(mise activate bash)"` の後、`task analyze` と `task build-all` を必ず実行する
- `task run` はユーザーが手動で確認するため、こちらからは実行しない
- Freezed / Riverpod のコード生成が必要な場合は `task` のコード生成タスクで再生成する（feature を新規追加した場合は必須）

## 参考

- AGENTS.md "Reducer 設計" 節（このスキルの規約の正本）
- `lib/helper/date_formatter.dart` の `DateFormatter` — Action に `DateTime` を載せ、Effect / 表示層で整形する
- `pubspec.yaml`: `flutter_hooks: 0.21.3+1` / `hooks_riverpod: 3.1.0` / `freezed: 3.2.3`（いずれも `useReducer` と sealed Freezed に対応済み）
