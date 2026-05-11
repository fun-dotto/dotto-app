# ツール

- dotto-figma
  - Figmaのリンクが提供されたときには、MCPを使用してアクセスすること。
- dotto-notion
  - Notionのリンクが提供されたときには、MCPを使用してアクセスすること。
- firebase-mcp-server
  - Crashlyticsを使用したCrashの分析に使用すること。

# ルール

- DRY 原則を遵守する
- SOLID 原則を遵守する
- ビルドやテスト、フォーマット、分析などのコマンドは Taskfile.yml にあるものを使用すること。
- コミット
  - 変更は都度コミットすること。
  - できるだけ小さい粒度でコミットすること。
  - メッセージは日本語で記述すること。
- Pull Request
  - ドラフトで作成すること。
  - 自分自身をAssigneeとして設定すること。
  - 現時点から最も近い将来のマイルストーンを設定すること。
  - タイトルと本文は全て日本語で記述すること。
  - 本文はテンプレートの形式を引き継ぐこと。

# Flutter

- Riverpod
  - riverpod_annotationを使用すること。
- Freezed
  - ドメインモデルのclassでは、freezed_annotationを使用すること。
- アーキテクチャ
  - クリーンアーキテクチャを意識した設計を遵守すること。
  - Hooks + Riverpod + Reducer + Repository パターンで実装すること。
  - MVVM + UseCase + Repository パターンが使われていることがあるが、現在は非推奨。
  - Riverpod Notifier の上にメソッド束を生やしただけの Reducer（名ばかりReducer）も非推奨。後述の `useReducer` ベース設計に置き換えること。
  - 移行方針: 新規 feature は必ず `useReducer` ベース設計で実装する。既存の名ばかりReducer は当該画面に手を入れる際に段階的に本設計へ移行し、大規模一括リファクタは行わない。
  - RepositoryはRiverpodに依存しないこと。
  - Repositoryは互いに独立していること。
  - Repository が画面層に例外を伝播させる場合は、`DomainError` に変換して throw すること。生の `DioException` / `FirebaseException` / `Exception` をそのまま投げない。
- Reducer 設計（`useReducer` ベース）
  - 画面ローカルで完結する状態は Widget ローカルの `useReducer` で管理する。Riverpod Notifier に画面ローカル状態を載せない。画面横断で共有したい状態のみ Riverpod Notifier に置き、名称に "Reducer" は付けない。
  - feature 単位で以下6ファイル構成に分割する。
    - `<feature>_state.dart` — Freezed な State
    - `<feature>_action.dart` — Freezed `sealed class` な Action（union）
    - `<feature>_reducer.dart` — 純粋関数 `reduce(state, action) -> state`
    - `<feature>_effects.dart` — `useEffect` ベースの Effect フック（副作用層）
    - `<feature>_store.dart` — `use<Feature>Store()` 合成フック
    - `<feature>_screen.dart` — `HookConsumerWidget`
  - State は Freezed class とし、非同期で取得する各値を `AsyncValue<T>` フィールドとして保持する（State 全体を `AsyncValue` でラップしない）。
  - Action は必ず Freezed `sealed class` にし、User intent（`xxxToggled` / `xxxSelected` / `xxxRequested`）と System result（`xxxLoaded` / `xxxFailed`）を命名で区別する。
    - ロード開始は user intent なら `xxxRequested` を dispatch し、Effect 側で検知して Repository を呼ぶ。画面表示時の自動ロードなど system 起点のトリガーは Effect 内で完結させ、専用 Action を発行しない。
  - `reduce` 関数の中では以下を禁止する:
    - `Future` / `async` / `await` / Repository 呼び出し / `ref` 参照
    - `DateTime.now()` / `Random` など時刻・乱数の参照（必要なら Action に詰めて渡す）
    - `print` / `Logger` などのログ出力
  - 副作用は `useEffect` ベースの Effect フックからのみ行う。
    - `useEffect` のキーは「どの state 変化で再実行するか」を明示する。
    - クリーンアップ関数で cancel フラグを立て、dispose（アンマウント）後に dispatch しないようにする。
    - 独立した副作用は `useEffect` を分割する（1つに詰めない）。
    - Repository 例外は `DomainError` に変換済み前提で catch し、失敗 Action を dispatch する。
  - `use<Feature>Store()` は `useReducer` と `use<Feature>Effects` を合成し、`{state, dispatch}` を返す薄いラッパーとする。
  - Repository は `HookConsumerWidget` の `WidgetRef` から `ref.read(xxxRepositoryProvider)` で取得し、Effect フックに注入する。Reducer 本体に `@riverpod` は付けない（Repository Provider には引き続き `@riverpod` を使う）。
  - パフォーマンス: `useReducer` の state 更新は当該 `HookConsumerWidget` 全体を rebuild する。画面が肥大化する場合は feature を分割するか、重い子 Widget は `const` 化／`HookBuilder` 切り出しで rebuild スコープを絞ること。
  - 実装・レビュー・移行は、本節「Reducer 設計（`useReducer` ベース）」に記載の手順とルールに従う。
- 日付整形
  - `DateFormat` は各所で直接使わず、`lib/helper/date_formatter.dart` の `DateFormatter` クラスにメソッドとして定義して利用すること。
