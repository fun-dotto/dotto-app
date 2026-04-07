# Dotto ネイティブアプリ化 実装計画

## Context

FlutterアプリをiOS/Androidネイティブアプリに置き換える。Flutterアプリは公立はこだて未来大学の学生向けコンパニオンアプリで、6タブ構成（講義・学食・マップ・バス・科目検索・設定）。BFF APIはOpenAPI 3.1.0仕様あり、Firebase各種サービスを直接利用する機能もある。

**方針:**
- iOS: SwiftUI + TCA + swift-dependencies + swift-openapi-generator
- Android: UIはJetpack Compose、ドメインモデルのみSwift for Androidで共有、APIクライアントはKotlin (OpenAPI Generator)で別途生成
- iOSから先に着手

---

## モノレポ構成

```
dotto-app/
  flutter/                 # 既存（参照用、段階的にアーカイブ）
  openapi/                 # OpenAPI仕様（共有）
    openapi.yaml           # flutter/openapi/openapi.yaml から移動
  shared/                  # 純粋Swift（クロスプラットフォーム共有モデル）
    Package.swift
    Sources/
      DottoModels/         # ドメインモデル（enum, struct）※Foundationに依存しない
    Tests/
      DottoModelsTests/
  ios/                     # iOSアプリ（SwiftUI + TCA）
    Dotto.xcodeproj        # 既存
    Dotto/
      App/                 # DottoApp.swift, AppFeature (ルートReducer)
      Features/            # 各機能モジュール
        Course/
        Funch/
        Map/
        Bus/
        SubjectSearch/
        Settings/
        Onboarding/
      Clients/             # swift-dependencies用のクライアント定義
      Services/            # Firebase等のプラットフォーム固有実装
      Resources/           # Assets, Localizations
    Packages/
      DottoAPIClient/      # swift-openapi-generator生成のAPIクライアント
        Package.swift
        Sources/
          openapi.yaml     # (symlink to /openapi/openapi.yaml)
          openapi-generator-config.yaml
  android/                 # Androidアプリ（Jetpack Compose）
    app/
    shared-bridge/         # Swift for Android JNIブリッジ
```

---

## Phase 0: 基盤整備

### 0-1. OpenAPI仕様の移動
- `flutter/openapi/openapi.yaml` → `openapi/openapi.yaml`

### 0-2. 共有Swiftパッケージ (`shared/`)
- `DottoModels` ターゲット: Foundation非依存の純粋Swiftモデル
- Flutterの `lib/domain/` から移植する型:
  - **Enum**: `Grade`, `Course`, `CourseSemester`, `AcademicClass`, `Period`, `DayOfWeek`, `Floor`, `SubjectClassification`, `SubjectRequirementType`, `CulturalSubjectCategory`, `PersonalCalendarItemStatus`, `LectureStatus`, `BusType`, `FunchMenuCategory`, `TabItem`
  - **Struct**: `DottoUser`, `Announcement`, `TimetableItem`, `TimetableSlot`, `PersonalCalendarItem`, `PersonalTimetableDay`, `CancelledClass`, `MakeupClass`, `RoomChange`, `CourseRegistration`, `SubjectSummary`, `SubjectDetail`, `Syllabus`, `Faculty`, `SubjectFeedback`, `Room`, `RoomSchedule`, `BusStop`, `BusTrip`, `FunchMenu`, `FunchDailyMenu`, `FunchPrice`, `Config`
- 全型に `Sendable`, `Equatable`, `Codable` 準拠

### 0-3. iOS APIクライアントパッケージ (`ios/Packages/DottoAPIClient/`)
- swift-openapi-generator + swift-openapi-runtime + swift-openapi-urlsession
- `openapi-generator-config.yaml`:
  ```yaml
  generate:
    - types
    - client
  accessModifier: public
  ```
- 認証ミドルウェア: `ClientMiddleware`プロトコルで実装
  - Bearer token (Firebase Auth IDトークン)
  - App Check token (`X-Firebase-AppCheck`ヘッダー)
  ```swift
  struct AuthMiddleware: ClientMiddleware {
      let tokenProvider: AuthTokenProvider
      func intercept(_ request: ...) async throws -> ... {
          var request = request
          if let bearer = try await tokenProvider.bearerToken() {
              request.headerFields[.authorization] = "Bearer \(bearer)"
          }
          if let appCheck = try await tokenProvider.appCheckToken() {
              request.headerFields[.init("X-Firebase-AppCheck")!] = "Bearer \(appCheck)"
          }
          return try await next(request, baseURL, operationID)
      }
  }
  ```

### 0-4. iOS Xcodeプロジェクト設定
- SPM依存追加:
  - `pointfreeco/swift-composable-architecture` (TCA)
  - `pointfreeco/swift-dependencies`
  - `firebase/firebase-ios-sdk` (Auth, AppCheck, Messaging, Crashlytics, Analytics, Firestore, Database, Storage, RemoteConfig)
  - `google/GoogleSignIn-iOS`
  - ローカル: `shared/` (DottoModels)
  - ローカル: `ios/Packages/DottoAPIClient/`

---

## Phase 1: iOS アプリシェル + 認証基盤

### 1-1. AppFeature (ルートReducer)
```
AppFeature
├── State
│   ├── selectedTab: TabItem
│   ├── isAuthenticated: Bool
│   ├── hasShownOnboarding: Bool
│   ├── appVersionStatus: AppVersionStatus
│   └── 各タブのState
├── Action
│   ├── onAppear
│   ├── tabSelected(TabItem)
│   ├── authStateChanged(Bool)
│   └── 各タブのAction (delegate)
└── body: 各Feature子Reducerのcompose
```

### 1-2. Firebase初期化 + 認証フロー
- `DottoApp.swift`でFirebase.configure()
- `AuthClient` (swift-dependencies):
  - `signInWithGoogle() async throws -> User`
  - `signOut() async throws`
  - `currentUser: User?`
  - `authStateChanges: AsyncStream<User?>`
  - `getIDToken() async throws -> String`
- `AppCheckClient`: `getToken() async throws -> String`
- `RemoteConfigClient`: `fetch() async throws -> Config`

### 1-3. タブナビゲーション
- TCA の `@Reducer(state: .equatable)` で各タブをcase reducerとして合成
- SwiftUI `TabView` + `@Bindable` で選択タブをバインド
- 参照: `flutter/lib/feature/root/root_screen.dart` のタブ構成
  - v2タブ: Course, Funch, Map, Bus, Settings
  - Funch無効時: Funch → SubjectSearchに差し替え (RemoteConfigで制御)

---

## Phase 2: iOS 各機能実装

### 2-1. Settings (設定) — 最初に実装
**理由**: 認証パイプラインのE2E検証、最もシンプル

**TCA構成:**
```
SettingsFeature
├── UserInfoSection (grade, course, class表示・編集)
├── SignIn / SignOut
├── AnnouncementsList (BFF API)
├── Tutorial (Onboarding再表示)
├── GitHubContributors (GitHub API)
├── License (Bundle内)
└── AppVersion + API環境切替 (Debug)
```

**依存クライアント:**
- `AuthClient` — Firebase Auth
- `UserClient` — BFF API (`GET/POST /v1/users`)
- `AnnouncementClient` — BFF API (`GET /v1/announcements`)
- `UserPreferenceClient` — UserDefaults

**参照ファイル:**
- `flutter/lib/feature/setting/settings.dart`
- `flutter/lib/controller/user_controller.dart`
- `flutter/lib/repository/announcement_repository.dart`

### 2-2. Bus (バス) — 2番目に実装
**理由**: Firebase Realtime Database連携の検証、自己完結

**TCA構成:**
```
BusFeature
├── BusStopList (出発・到着停留所選択)
├── BusTimetable (時刻表表示)
└── State: selectedDeparture, selectedArrival, trips
```

**依存クライアント:**
- `BusClient` — Firebase Realtime Database (`bus/stops`, `bus/trips`)

**参照ファイル:**
- `flutter/lib/feature/bus/bus_screen.dart`
- `flutter/lib/feature/bus/bus_reducer.dart`
- `flutter/lib/repository/bus_repository.dart`

### 2-3. Course (講義) — 3番目に実装
**理由**: コアの機能、BFF APIの包括的な利用

**TCA構成:**
```
CourseFeature
├── PersonalTimetableCalendar (週表示カレンダー)
│   ├── 4週間分の日付生成 (アンカーMonday計算)
│   └── personalCalendarItems APIコール
├── CourseRegistration
│   ├── 登録済み一覧 (GET /v1/courseRegistrations)
│   ├── 科目選択 → 登録 (POST)
│   └── 削除 (DELETE)
├── CourseCancellation
│   ├── 休講一覧 (GET /v1/cancelledClasses)
│   ├── 補講一覧 (GET /v1/makeupClasses)
│   └── 教室変更一覧 (GET /v1/roomChanges)
└── ExternalLinks (学年暦PDF等)
```

**依存クライアント:**
- `PersonalCalendarClient` — BFF API
- `CourseRegistrationClient` — BFF API
- `CancelledClassClient` — BFF API
- `MakeupClassClient` — BFF API
- `RoomChangeClient` — BFF API
- `TimetableClient` — BFF API (`GET /v1/timetableItems`)

**参照ファイル:**
- `flutter/lib/feature/course/course_reducer.dart`
- `flutter/lib/feature/course/course_registration_reducer.dart`
- `flutter/lib/feature/course/course_cancellation_reducer.dart`
- `flutter/lib/repository/personal_calendar_repository.dart`
- `flutter/lib/repository/course_registration_repository.dart`
- `flutter/lib/repository/timetable_repository.dart`

### 2-4. Subject Search (科目検索) — 4番目
**TCA構成:**
```
SubjectSearchFeature
├── SearchForm (テキスト検索 + フィルター)
│   └── SubjectFilter: grades, courses, classes, classifications,
│       semesters, requirementTypes, culturalSubjectCategories
├── SubjectList (検索結果一覧)
├── SubjectDetail
│   ├── SyllabusTab (シラバス情報)
│   ├── FeedbackTab (Firestoreからの口コミ)
│   │   └── AddFeedback (評価投稿)
│   └── PastExamTab (過去問リンク)
└── Navigation: stack-based
```

**依存クライアント:**
- `SubjectClient` — BFF API (`GET /v1/subjects`, `GET /v1/subjects/{id}`)
- `SubjectFeedbackClient` — Cloud Firestore (`feedback`コレクション)
- `SyllabusDBClient` — ローカルSQLite (過去問ID検索)

**参照ファイル:**
- `flutter/lib/feature/subject/search_subject_reducer.dart`
- `flutter/lib/feature/subject/subject_detail_screen.dart`
- `flutter/lib/repository/subject_repository.dart`

### 2-5. Funch (学食) — 5番目
**TCA構成:**
```
FunchFeature
├── MenuList (日別メニュー表示)
│   ├── 日付選択
│   └── カテゴリフィルター
├── PriceList (価格表)
└── MypageCard (カルーセル)
```

**依存クライアント:**
- `FunchClient` — Firebase Firestore + Storage

**参照ファイル:**
- `flutter/lib/feature/funch/`
- `flutter/lib/repository/funch_repository.dart`

### 2-6. Map (マップ) — 6番目（最も複雑なUI）
**TCA構成:**
```
MapFeature
├── FloorSelector (1F〜7F + Virtual)
├── MapGrid (キャンパスマップ描画)
├── RoomSearch
├── RoomDetail (BottomSheet)
│   └── RoomSchedule表示
└── State: selectedFloor, rooms, selectedRoom
```

**依存クライアント:**
- `RoomClient` — Firebase Realtime Database (`map`, `map_room_schedule`)

**参照ファイル:**
- `flutter/lib/feature/map/`
- `flutter/lib/repository/room_repository.dart`

---

## Phase 3: iOS 横断的機能

### 3-1. プッシュ通知 (FCM)
- FCMトークン取得 → `POST /v1/fcmTokens`
- ユーザーログイン時にトークン登録
- 参照: `flutter/lib/controller/user_controller.dart`

### 3-2. Crashlytics + Analytics
- クラッシュレポート自動送信
- 画面遷移トラッキング

### 3-3. App Check
- Apple DeviceCheck / App Attest
- APIリクエストにトークン注入

### 3-4. アプリバージョンチェック
- RemoteConfig: `validAppVersion`, `latestAppVersion`, `appStorePageUrl`
- 無効バージョン → ブロック画面
- 古いバージョン → 更新アラート
- 参照: `flutter/lib/feature/root/root_viewmodel.dart`

### 3-5. オンボーディング
- 初回起動時のチュートリアル表示
- 参照: `flutter/lib/feature/onboarding/onboarding_screen.dart`

---

## Phase 4: Android アプリ

### 4-1. 共有モデルブリッジ
- `shared/` の `DottoModels` を Swift for Android でビルド (.so)
- `swift-java` (swiftlang/swift-java) でKotlinバインディング生成
- または: OpenAPI specからKotlinモデルも自動生成し、Swift共有は段階的に導入

### 4-2. Android APIクライアント
- OpenAPI Generator (Kotlin) で `openapi/openapi.yaml` からクライアント生成
- Retrofit + OkHttp (または Ktor)
- 同じ認証ミドルウェアパターン (Firebase Auth + App Check)

### 4-3. Android Compose UI
- 各画面をJetpack Composeで実装
- Firebase Android SDK（ネイティブサポート充実）
- Navigation Compose + ViewModel

### 4-4. 実装順序
iOS と同じ順序: Settings → Bus → Course → SubjectSearch → Funch → Map

---

## swift-dependencies クライアント一覧

| クライアント名 | データソース | 用途 |
|---|---|---|
| `AuthClient` | Firebase Auth + Google Sign-In | 認証 |
| `AppCheckClient` | Firebase App Check | APIトークン |
| `RemoteConfigClient` | Firebase Remote Config | 機能フラグ |
| `FCMClient` | Firebase Messaging | プッシュ通知 |
| `AnalyticsClient` | Firebase Analytics | 分析 |
| `CrashlyticsClient` | Firebase Crashlytics | クラッシュ |
| `UserClient` | BFF API | ユーザー情報 |
| `AnnouncementClient` | BFF API | お知らせ |
| `PersonalCalendarClient` | BFF API | 個人カレンダー |
| `CourseRegistrationClient` | BFF API | 履修登録 |
| `CancelledClassClient` | BFF API | 休講 |
| `MakeupClassClient` | BFF API | 補講 |
| `RoomChangeClient` | BFF API | 教室変更 |
| `TimetableClient` | BFF API | 時間割 |
| `SubjectClient` | BFF API | 科目検索 |
| `SubjectFeedbackClient` | Cloud Firestore | 口コミ |
| `BusClient` | Realtime Database | バス |
| `RoomClient` | Realtime Database | 教室マップ |
| `FunchClient` | Firestore + Storage | 学食メニュー |
| `UserPreferenceClient` | UserDefaults | ローカル設定 |
| `SyllabusDBClient` | SQLite | 過去問検索 |

---

## 検証方法

1. **共有モデル**: ユニットテストでCodable往復変換を検証
2. **APIクライアント**: MockTransportでOpenAPIレスポンスをテスト
3. **TCA Reducers**: `TestStore`で各Action→State変化を検証 (swift-dependenciesのtestValueを利用)
4. **Firebase連携**: 実機/シミュレータで各Firebase SDKの動作確認
5. **E2E**: 既存FlutterアプリとネイティブアプリでAPI応答を比較
6. **ビルド**: `xcodebuild -scheme Dotto -destination 'platform=iOS Simulator,...' build test`
