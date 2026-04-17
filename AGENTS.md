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
  - クリーンアーキテクチャを意識した設計を準州すること。
  - Hooks + Riverpod + Reducer + Repository パターンで実装すること。
  - MVVM + UseCase + Repository パターンが使われていることがあるが、現在は非推奨。
  - RepositoryはRiverpodに依存しないこと。
  - Repositoryは互いに独立していること。
  - Repository が画面層に例外を伝播させる場合は、`DomainError` に変換して throw すること。生の `DioException` / `FirebaseException` / `Exception` をそのまま投げない。
- 日付整形
  - `DateFormat` は各所で直接使わず、`lib/helper/date_formatter.dart` の `DateFormatter` クラスにメソッドとして定義して利用すること。
