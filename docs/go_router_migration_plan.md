# Go Router 移行方針

## 概要

現在 `Navigator`（命令型ナビゲーション）で実装されているルーティングを、`go_router`（宣言型ナビゲーション）に置き換える。

## 現状分析

### 現在のルーティング構成

| 要素 | 現在の実装 |
|------|-----------|
| エントリポイント | `MaterialApp.home` → `RootScreen` |
| タブナビゲーション | `IndexedStack` + タブごとの `Navigator` ウィジェット |
| タブ管理 | `NavigationBar` + `RootViewModel`（Riverpod Notifier） |
| 画面遷移 | `Navigator.of(context).push(MaterialPageRoute(...))` |
| 戻る制御 | `PopScope` + `maybePop()` / `popUntil()` |
| ディープリンク | `app_links` パッケージ（現在は listen のみ、ルーティング未連携） |
| Analytics | `FirebaseAnalyticsObserver` を `MaterialApp.navigatorObservers` に設定 |

### 画面一覧とルート構造

#### タブ（`TabItem` enum / `NavigationBar`）

| タブ | 画面 | 現在のルート名 |
|------|------|---------------|
| 講義 | `CourseScreen` | `/course` |
| 学食 | `FunchScreen` | `/funch` |
| マップ | `MapScreen` | `/map` |
| バス | `BusScreen` | `/bus` |
| 設定 | `SettingsScreen` | `/setting` |
| 科目検索 | `SearchSubjectScreen` | `/subject`（学食無効時に学食タブと差し替え） |

#### 講義タブ配下

| 画面 | 現在のルート名 | パラメータ |
|------|---------------|-----------|
| `SearchSubjectScreen` | `/course/subjects` | なし |
| `CourseCancellationScreen` | `/course/irregular_classes` | なし |
| `WebPdfViewer` | `/course/web_pdf_viewer?url=...` | `url`, `filename` |
| `CourseCustomizeScreen` | `/course/preferences` | なし |
| `SubjectDetailScreen` | `/course/subjects/:id` | `id` |
| `CourseRegistrationScreen` | `/course/registration` | なし |

#### バスタブ配下

| 画面 | 現在のルート名 | パラメータ |
|------|---------------|-----------|
| `BusStopSelectScreen` | `/bus/select_stop` | なし |
| `BusTimetableScreen` | `/bus/timetable?route=...` | `busTrip`（オブジェクト） |

#### 科目詳細配下

| 画面 | 現在のルート名 | パラメータ |
|------|---------------|-----------|
| `SubjectDetailScreen` | `/subjects/:id` | `id` |
| 過去問の PDF ビューア | `/subjects/:id/past_exam/:pastExamId` | `pastExamId`, `pastExamUrl` |

#### 設定タブ配下

| 画面 | 現在のルート名 | パラメータ |
|------|---------------|-----------|
| `AnnouncementScreen` | `/setting/announcements` | なし |
| `GitHubContributorScreen` | `/setting/developers` | なし |
| `OnboardingScreen` | `/setting/onboarding` | なし |
| `SettingsLicenseScreen` | `/setting/licenses` | なし |
| `DebugScreen` | `/setting/debug` | なし |

#### その他

| 画面 | 条件 |
|------|------|
| `OnboardingScreen` | 初回起動時（チュートリアル未完了） |
| `InvalidAppVersionScreen` | アプリバージョン無効時 |

## 移行方針

### 1. パッケージ導入

`pubspec.yaml` に追加:

```yaml
dependencies:
  go_router: ^15.1.2
```

### 2. ルート定義（`StatefulShellRoute` によるタブナビゲーション）

Go Router の `StatefulShellRoute.indexedStack` を使用し、現在の `IndexedStack` + ネスト `Navigator` 構成をそのまま置き換える。

```
/                          → RootScreen（シェル）
├── /course                → CourseScreen
│   ├── /course/subjects   → SearchSubjectScreen
│   │   └── /course/subjects/:id → SubjectDetailScreen
│   ├── /course/irregular_classes → CourseCancellationScreen
│   ├── /course/registration → CourseRegistrationScreen
│   ├── /course/preferences → CourseCustomizeScreen
│   └── /course/pdf?url=...&filename=... → WebPdfViewer
├── /funch                 → FunchScreen
├── /map                   → MapScreen
├── /bus                   → BusScreen
│   ├── /bus/select_stop   → BusStopSelectScreen
│   └── /bus/timetable/:route → BusTimetableScreen
├── /setting               → SettingsScreen
│   ├── /setting/announcements → AnnouncementScreen
│   ├── /setting/developers → GitHubContributorScreen
│   ├── /setting/onboarding → OnboardingScreen
│   ├── /setting/licenses  → SettingsLicenseScreen
│   └── /setting/debug     → DebugScreen
└── /subject               → SearchSubjectScreen（学食無効時）
    └── /subject/:id       → SubjectDetailScreen
```

### 3. ルーター定義ファイルの新設

`lib/routing/` ディレクトリを新設し、以下のファイルを配置する:

| ファイル | 責務 |
|---------|------|
| `app_router.dart` | `GoRouter` インスタンスの生成（Riverpod Provider） |
| `routes.dart` | ルート定義（`StatefulShellRoute` + 各 `GoRoute`） |
| `route_names.dart` | ルート名の定数定義 |

`GoRouter` は Riverpod Provider として定義し、`ref` 経由で `redirect` やガードに必要な状態（認証状態、チュートリアル完了フラグ、アプリバージョン等）を参照できるようにする。

### 4. `MaterialApp` → `MaterialApp.router` への変更

`app.dart` を以下のように変更:

```dart
MaterialApp.router(
  routerConfig: ref.watch(appRouterProvider),
  // ...既存のテーマ・ローカライゼーション設定
)
```

### 5. リダイレクトによるガード処理

現在 `RootScreen.build()` 内で `if` 分岐している以下のガード処理を、`GoRouter.redirect` に移行する:

| 条件 | 現在の処理 | Go Router での処理 |
|------|-----------|-------------------|
| チュートリアル未完了 | `OnboardingScreen` を直接表示 | `/onboarding` にリダイレクト |
| アプリバージョン無効 | `InvalidAppVersionScreen` を直接表示 | `/invalid_version` にリダイレクト |

### 6. ダイアログ・BottomSheet

`showDialog` / `showModalBottomSheet` はルーティング対象外とし、現在の命令型呼び出しをそのまま維持する。Go Router のルートとしては定義しない。

### 7. `Navigator.of(context).pop()` の扱い

- ダイアログ内: `Navigator.of(context).pop()` をそのまま維持（ダイアログは Go Router 管理外）
- 画面遷移の戻り: `context.pop()` に置き換え
- 結果を返す `pop(result)`: `context.pop(result)` に置き換え

### 8. 同一タブ再タップでルートまで戻る挙動

現在 `RootViewModel.onTabItemTapped` で `NavigatorState.popUntil` を使っている。Go Router では `StatefulShellRoute` の `NavigatorState` にアクセスして同等の処理を実装するか、各タブブランチの初期ルートにリダイレクトする方式を採用する。

### 9. Android の戻るボタン制御

現在 `PopScope` + `maybePop()` で実装している Android バックボタン制御は、Go Router のネスト `Navigator` が自動的に処理するため、明示的な `PopScope` は不要になる可能性がある。動作確認の上で削除を判断する。

### 10. Firebase Analytics 連携

`FirebaseAnalyticsObserver` を `GoRouter.observers` に設定する。Go Router は `RouteSettings.name` ではなく `GoRoute.name` / `GoRoute.path` をもとにスクリーン名を報告するため、既存の Analytics データとの整合性を確認する。

### 11. ディープリンク対応

現在 `app_links` パッケージで `uriLinkStream` を listen しているが、ルーティングとの連携はされていない。Go Router はディープリンクをネイティブサポートしているため、`app_links` の直接利用は不要になる。ルート定義にパスを定義するだけでディープリンクが機能する。

### 12. オブジェクトパラメータの受け渡し

`BusTimetableScreen` のように画面遷移時にオブジェクト（`BusTrip`）を渡すケースは、Go Router の `extra` パラメータを使用する。ただし `extra` はディープリンクで復元できないため、将来的には ID ベースのパラメータに変更することを推奨する。

### 13. 動的タブ切り替え（学食 ↔ 科目検索）

`isFunchEnabled` フラグによるタブの動的切り替えは、`StatefulShellRoute` のブランチ定義を条件分岐で構築するか、`redirect` でハンドリングする。

## 移行手順

### Phase 1: 基盤構築

1. `go_router` パッケージの追加
2. `lib/routing/` にルート定義ファイルを作成
3. `MaterialApp.router` への切り替え
4. `StatefulShellRoute.indexedStack` でタブナビゲーションを実装
5. 各タブのルートスクリーンのみ定義（サブルートは Phase 2）

### Phase 2: 画面遷移の移行

1. 各 feature の `Navigator.of(context).push(MaterialPageRoute(...))` を `context.go()` / `context.push()` に逐次置換
2. `Navigator.of(context).pop()` を `context.pop()` に置換（ダイアログ内を除く）
3. `RouteSettings` の削除

### Phase 3: ガード・リダイレクトの移行

1. `redirect` でオンボーディング / バージョンチェックのガード実装
2. `RootScreen` からガードロジックを削除
3. `RootViewModel` の `navigatorKeys` 関連コードを削除

### Phase 4: ディープリンク対応

1. Go Router のディープリンク設定
2. `app_links` パッケージの利用箇所を Go Router に統合
3. 不要になった `app_links` の listen 処理を削除

### Phase 5: クリーンアップ

1. 未使用の `Navigator` 関連コード・import の削除
2. `RootViewModelState` から `navigatorKeys` フィールドを削除
3. Firebase Analytics の動作確認
4. 全画面遷移の動作確認・回帰テスト

## 注意事項

- 移行は Phase ごとに PR を分けて段階的に行い、大規模一括リファクタは避ける（AGENTS.md の方針に準拠）。
- 各 Phase で全プラットフォーム（iOS / Android / Web）の動作確認を行う。
- Analytics のスクリーン名が変わる可能性があるため、移行前後のデータ比較を行う。
- `extra` でオブジェクトを渡しているルートは、ディープリンク対応時に ID ベースに変更する。
