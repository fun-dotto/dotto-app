import 'package:dotto/asset.dart';

class OnboardingPage {
  const OnboardingPage({required this.title});

  final String title;

  static const pages = <OnboardingPage>[
    OnboardingWelcomePage(
      title: 'ようこそ',
      bodyTop: 'Dottoで',
      bodyBottom: 'はこだて未来大学のすべてを',
    ),
    OnboardingContentPage(
      title: '時間割の管理',
      description: '自分の時間割を設定して\n休講/補講情報を受け取ろう',
      imagePath: Asset.tutorialTimetableMock,
    ),
    OnboardingContentPage(
      title: 'バスの時刻表',
      description: '大学から最寄りのバス停までの\n時刻表を確認しよう',
      imagePath: Asset.tutorialBusMock,
    ),
    OnboardingContentPage(
      title: '学内マップ',
      description: '空き教室を確認したり\n研究室を検索しよう',
      imagePath: Asset.tutorialCampusMapMock,
    ),
    OnboardingContentPage(
      title: '科目検索',
      description: 'レビューや過去問を\n閲覧しよう',
      imagePath: Asset.tutorialSubjectMock,
    ),
    OnboardingContentPage(
      title: '学食メニュー',
      description: '学食のメニューや価格を\n確認しよう',
      imagePath: Asset.tutorialCafeteriaMock,
    ),
  ];
}

final class OnboardingWelcomePage extends OnboardingPage {
  const OnboardingWelcomePage({
    required super.title,
    required this.bodyTop,
    required this.bodyBottom,
  });

  final String bodyTop;
  final String bodyBottom;
}

final class OnboardingContentPage extends OnboardingPage {
  const OnboardingContentPage({
    required super.title,
    required this.description,
    required this.imagePath,
  });

  final String description;
  final String imagePath;
}
