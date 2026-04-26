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
  - ファイル構成・命名・State / Action / Reducer / Effects / Store のテンプレート、`reduce` の純粋性チェックリスト、名ばかりReducer からの移行手順、パフォーマンス指針は、スキル `flutter-hooks-reducer` を参照し、同スキルに従って実装・レビュー・移行を行う。
- 日付整形
  - `DateFormat` は各所で直接使わず、`lib/helper/date_formatter.dart` の `DateFormatter` クラスにメソッドとして定義して利用すること。
