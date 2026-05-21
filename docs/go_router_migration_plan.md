# Go Router 移行方針

> **注記**: 本ドキュメント内のファイルパスは、特に断りがない限り `apps/dotto/` を基準とする（melos ワークスペース構成のため）。

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

タブのルート名は明示的に定義されたものではなく、`'/${tab.name}'` で動的生成されている（`root_screen.dart:286`）。以下の表は生成結果を記載している。

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

| 画面 | 現在のルート名 | パラメータ | 備考 |
|------|---------------|-----------|------|
| `SubjectDetailScreen` | `/subjects/:id` | `id` | |
| 過去問の PDF ビューア | `/subjects/$pastExamId/past_exams/$filename` | `pastExamId`, `filename` | 実コードにも TODO あり。移行後は `/subjects/:subjectId/past_exams/:pastExamId` に修正する（後述） |

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

`apps/dotto/pubspec.yaml` に追加:

```yaml
dependencies:
  go_router: ^15.1.2
```

> **注意**: 並行 PR #592 で Flutter 3.44.0 / Dart 3.12.0 へのアップグレードが進行中。go_router のバージョンは、マージ後の Flutter / Dart バージョンとの互換性を確認した上で決定する。

### 2. ルート定義（`StatefulShellRoute` によるタブナビゲーション）

Go Router の `StatefulShellRoute.indexedStack` を使用し、現在の `IndexedStack` + ネスト `Navigator` 構成をそのまま置き換える。

移行後のルートパス設計では、現状のパス表記ゆれを以下のように統一する:

- 科目検索タブ: `/subjects`（複数形に統一。実コードの `/subjects/...` に合わせる）
- 講義タブからの科目検索: `/course/subjects`（タブ内サブルートとして維持）
- PDF ビューア: `/course/web_pdf_viewer`（現在のルート名を維持。構造図での `/course/pdf` は採用しない）
- 過去問 PDF: `/subjects/:subjectId/past_exams/:pastExamId`（既存の TODO に従い正しいパス構造に修正）

```
/                          → RootScreen（シェル）
├── /course                → CourseScreen
│   ├── /course/subjects   → SearchSubjectScreen
│   │   └── /course/subjects/:id → SubjectDetailScreen
│   ├── /course/irregular_classes → CourseCancellationScreen
│   ├── /course/registration → CourseRegistrationScreen
│   ├── /course/preferences → CourseCustomizeScreen
│   └── /course/web_pdf_viewer?url=...&filename=... → WebPdfViewer
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
└── /subjects              → SearchSubjectScreen（学食無効時）
    └── /subjects/:id      → SubjectDetailScreen
        └── /subjects/:subjectId/past_exams/:pastExamId → CloudflarePdfViewer
```

### 3. ルーター定義ファイルの新設

`lib/routing/` ディレクトリを新設し、以下のファイルを配置する:

| ファイル | 責務 |
|---------|------|
| `app_router.dart` | `GoRouter` インスタンスの生成（Riverpod Provider） |
| `routes.dart` | ルート定義（`StatefulShellRoute` + 各 `GoRoute`） |
| `route_names.dart` | ルート名の定数定義 |

`GoRouter` は Riverpod Provider として定義し、`ref` 経由で `redirect` やガードに必要な状態（認証状態、チュートリアル完了フラグ、アプリバージョン等）を参照できるようにする。

> **重要: `GoRouter` インスタンスの安定性**
>
> `GoRouter` を Riverpod Provider で管理する際、`ref.watch` した状態が変わるたびに Provider が再評価されると `GoRouter` インスタンスが再生成され、ナビゲーションスタックがリセットされる。これを避けるため、以下の方針を採る:
>
> - `GoRouter` インスタンス自体は一度だけ生成し、Provider 内で安定させる
> - 認証状態やフラグの変化は `GoRouter.refreshListenable` に `Listenable` 化した Notifier を渡すことで検知し、`redirect` を再評価させる
> - `ref.watch` ではなく `ref.read` + `refreshListenable` パターンを採用する

### 4. `MaterialApp` → `MaterialApp.router` への変更

`lib/app.dart` を以下のように変更:

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

> **注意: `StatefulShellRoute` との組み合わせ**
>
> `StatefulShellRoute` ではタブ内の遷移は各ブランチの `Navigator` を通るため、トップレベルの `GoRouter.observers` だけではタブ配下の画面遷移が Analytics に記録されない可能性がある。各 `StatefulShellBranch` の `observers` にも `FirebaseAnalyticsObserver` を設定する必要がある。

### 11. ディープリンク対応

現在 `app_links` パッケージで `uriLinkStream` を listen しているが、ルーティングとの連携はされていない（`root_viewmodel.dart:43-48` では listen のみで実質未使用）。Go Router はディープリンクをネイティブサポートしているため、`app_links` の直接利用は不要になる。

> **注意: ネイティブ設定は別途必要**
>
> Go Router のルート定義にパスを追加するだけではディープリンクは機能しない。以下のネイティブ側設定が別途必要:
>
> - **iOS**: Associated Domains の設定（`apple-app-site-association` ファイル + Xcode の Entitlements）
> - **Android**: `AndroidManifest.xml` への `intent-filter`（`autoVerify` 含む）+ `.well-known/assetlinks.json`
>
> これらの設定は Phase 4 で対応する。

### 12. オブジェクトパラメータの受け渡し

`BusTimetableScreen` のように画面遷移時にオブジェクト（`BusTrip`）を渡すケースは、Go Router の `extra` パラメータを使用する。ただし `extra` はディープリンクで復元できないため、将来的には ID ベースのパラメータに変更することを推奨する。

### 13. 動的タブ切り替え（学食 ↔ 科目検索）

`isFunchEnabled` フラグによるタブの動的切り替えは、本移行の最大の難所である。`StatefulShellRoute.indexedStack` は構築時にブランチ数が固定され、実行時にブランチを追加・削除できない。現状は `isFunchEnabled` で同一スロットの `TabItem.funch` ↔ `TabItem.subject` を入れ替えている（`root_viewmodel.dart:22-29`）。

以下の2案を検討し、**Phase 1 でプロトタイプ検証を行った上で決定する**:

| 案 | 概要 | メリット | デメリット |
|----|------|---------|-----------|
| A | `/funch` と `/subjects` の両ブランチを常に定義し、`NavigationBar` 側で表示/非表示を制御。無効なタブへのアクセスは `redirect` でガード | ナビゲーション状態が保持される。router の再生成が不要 | 非表示ブランチが内部的に存在し続ける |
| B | `isFunchEnabled` 変化時に `GoRouter` インスタンスを再生成 | ブランチ構造がフラグと完全一致 | ナビゲーションスタックがリセットされる。状態ロスのリスク |

**推奨: 案A**（状態保持の安定性を優先）

## 移行手順

### Phase 1: 基盤構築

1. `go_router` パッケージの追加
2. `lib/routing/` にルート定義ファイルを作成
3. `MaterialApp.router` への切り替え
4. `StatefulShellRoute.indexedStack` でタブナビゲーションを実装
5. 各タブのルートスクリーンのみ定義（サブルートは Phase 2）
6. **動的タブ切り替え（案A / 案B）のプロトタイプ検証**

### Phase 2: 画面遷移の移行

1. 各 feature の `Navigator.of(context).push(MaterialPageRoute(...))` を `context.go()` / `context.push()` に逐次置換
2. `Navigator.of(context).pop()` を `context.pop()` に置換（ダイアログ内を除く）
3. `RouteSettings` の削除
4. 過去問 PDF のルートパスを `/subjects/:subjectId/past_exams/:pastExamId` に修正

### Phase 3: ガード・リダイレクトの移行

1. `redirect` でオンボーディング / バージョンチェックのガード実装
2. `RootScreen` からガードロジックを削除
3. `RootViewModel` の `navigatorKeys` 関連コードを削除

### Phase 4: ディープリンク対応

1. iOS / Android のネイティブ設定（Associated Domains、intent-filter 等）
2. Go Router のディープリンク設定
3. `app_links` パッケージの利用箇所を Go Router に統合
4. 不要になった `app_links` の listen 処理を削除

### Phase 5: クリーンアップ

1. 未使用の `Navigator` 関連コード・import の削除
2. `RootViewModelState` から `navigatorKeys` フィールドを削除
3. Firebase Analytics の動作確認（トップレベル + 各 `StatefulShellBranch` の observer 動作検証）
4. 全画面遷移の動作確認・回帰テスト

## 注意事項

- 移行は Phase ごとに PR を分けて段階的に行い、大規模一括リファクタは避ける（AGENTS.md の方針に準拠）。
- 各 Phase で全プラットフォーム（iOS / Android / Web）の動作確認を行う。
- Analytics のスクリーン名が変わる可能性があるため、移行前後のデータ比較を行う。
- `extra` でオブジェクトを渡しているルートは、ディープリンク対応時に ID ベースに変更する。
