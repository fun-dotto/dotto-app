import 'package:dotto/asset.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class AppTutorial extends StatefulWidget {
  const AppTutorial({required this.onDismissed, super.key});

  final void Function() onDismissed;

  @override
  State<AppTutorial> createState() => _AppTutorialState();
}

final class _AppTutorialState extends State<AppTutorial> {
  final _controller = PageController();
  var _currentIndex = 0;

  static const _pages = <_TutorialPageData>[
    _TutorialPageData(welcomeTitle: 'ようこそ', welcomeBodyTop: 'Dottoで', welcomeBodyBottom: 'はこだて未来大学のすべてを'),
    _TutorialPageData(
      title: '時間割の管理',
      description: '自分の時間割を設定して\n休講/補講情報を受け取ろう',
      imagePath: Asset.tutorialTimetableMock,
      fallbackImagePath: Asset.tutorialHome,
    ),
    _TutorialPageData(
      title: 'バスの時刻表',
      description: '大学から最寄りのバス停までの\n時刻表を確認しよう',
      imagePath: Asset.tutorialBusMock,
      fallbackImagePath: Asset.tutorialMap,
    ),
    _TutorialPageData(
      title: '学内マップ',
      description: '空き教室を確認したり\n研究室を検索しよう',
      imagePath: Asset.tutorialCampusMapMock,
      fallbackImagePath: Asset.tutorialMap,
    ),
    _TutorialPageData(
      title: '科目検索',
      description: 'レビューや過去問を\n閲覧しよう',
      imagePath: Asset.tutorialSubjectMock,
      fallbackImagePath: Asset.tutorialKamoku,
    ),
    _TutorialPageData(
      title: '学食メニュー',
      description: '学食のメニューや価格を\n確認しよう',
      imagePath: Asset.tutorialCafeteriaMock,
      fallbackImagePath: Asset.tutorialKadai,
    ),
  ];

  bool get _isLastPage => _currentIndex == _pages.length - 1;

  void _goNextOrFinish() {
    if (_isLastPage) {
      widget.onDismissed();
      return;
    }
    _controller.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 24),
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(Asset.icon1024, width: 61, height: 61)),
          const Spacer(),
          DottoButton(onPressed: widget.onDismissed, type: DottoButtonType.text, child: const Text('スキップ')),
        ],
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context, _TutorialPageData page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  page.welcomeTitle!,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: SemanticColor.light.accentPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(Asset.icon1024, width: 132, height: 132),
                ),
                const SizedBox(height: 72),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Dotto',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: SemanticColor.light.accentPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'で',
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(color: SemanticColor.light.labelPrimary),
                      ),
                    ],
                  ),
                ),
                Text(
                  'はこだて未来大学のすべてを',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: SemanticColor.light.labelPrimary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturePage(BuildContext context, _TutorialPageData page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mockupHeight = (constraints.maxHeight * 0.74).clamp(300.0, 480.0).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Column(
            children: [
              Text(
                page.title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: SemanticColor.light.accentPrimary),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: mockupHeight + 12,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: _buildPhoneMockup(
                    imagePath: page.imagePath!,
                    fallbackImagePath: page.fallbackImagePath!,
                    mockupHeight: mockupHeight,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(page.description!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhoneMockup({
    required String imagePath,
    required String fallbackImagePath,
    required double mockupHeight,
  }) {
    final phoneWidth = mockupHeight * 0.54;
    return SizedBox(
      width: phoneWidth + 12,
      height: mockupHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: phoneWidth,
            height: mockupHeight,
            decoration: BoxDecoration(
              color: SemanticColor.light.backgroundSecondary,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: SemanticColor.light.borderPrimary),
              boxShadow: [
                BoxShadow(
                  color: SemanticColor.light.backgroundQuaternary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: AspectRatio(
                      aspectRatio: 1080 / 2130,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(fallbackImagePath, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SemanticColor.light.borderPrimary,
                              border: Border.all(color: SemanticColor.light.backgroundSecondary),
                            ),
                          ),
                          const SizedBox(width: 28),
                          Container(
                            width: 52,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: SemanticColor.light.backgroundTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(right: 0, top: mockupHeight * 0.33, child: _buildSideButton()),
          Positioned(right: 0, top: mockupHeight * 0.56, child: _buildSideButton()),
        ],
      ),
    );
  }

  Widget _buildSideButton() {
    return Container(
      width: 6,
      height: 52,
      decoration: BoxDecoration(color: SemanticColor.light.backgroundTertiary, borderRadius: BorderRadius.circular(4)),
    );
  }

  Widget _buildBottomArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final isActive = index == _currentIndex;
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: isActive ? Colors.black : Colors.black26, shape: BoxShape.circle),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DottoButton(onPressed: _goNextOrFinish, child: Text(_isLastPage ? 'はじめる' : '次へ')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  if (page.isWelcome) {
                    return _buildWelcomePage(context, page);
                  }
                  return _buildFeaturePage(context, page);
                },
              ),
            ),
            _buildBottomArea(context),
          ],
        ),
      ),
    );
  }
}

final class _TutorialPageData {
  const _TutorialPageData({
    this.title,
    this.description,
    this.imagePath,
    this.fallbackImagePath,
    this.welcomeTitle,
    this.welcomeBodyTop,
    this.welcomeBodyBottom,
  });

  final String? title;
  final String? description;
  final String? imagePath;
  final String? fallbackImagePath;
  final String? welcomeTitle;
  final String? welcomeBodyTop;
  final String? welcomeBodyBottom;

  bool get isWelcome => welcomeTitle != null;
}
