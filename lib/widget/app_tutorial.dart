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
        final topOffset = (constraints.maxHeight * 0.1).clamp(20.0, 72.0).toDouble();
        final middleGap = (constraints.maxHeight * 0.24).clamp(72.0, 140.0).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: Column(
              children: [
                SizedBox(height: topOffset),
                Text(
                  page.welcomeTitle!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: SemanticColor.light.accentPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(Asset.icon1024, width: 140, height: 140),
                ),
                SizedBox(height: middleGap),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Dotto',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: SemanticColor.light.accentPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.96,
                        ),
                      ),
                      TextSpan(
                        text: 'で',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: SemanticColor.light.labelPrimary),
                      ),
                    ],
                  ),
                ),
                Text(
                  'はこだて未来大学のすべてを',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: SemanticColor.light.labelPrimary, letterSpacing: 0.64),
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
        final bodyStyle = Theme.of(context).textTheme.bodyLarge;
        final estimatedDescriptionHeight = ((bodyStyle?.fontSize ?? 16) * (bodyStyle?.height ?? 1.4) * 2) + 8;
        final reservedHeight = 24 + 44 + 12 + 20 + estimatedDescriptionHeight;
        final imageHeight = (constraints.maxHeight - reservedHeight).clamp(280.0, 520.0).toDouble();
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          child: Column(
            children: [
              Text(
                page.title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: SemanticColor.light.accentPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: imageHeight,
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    page.imagePath!,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(page.fallbackImagePath!, height: imageHeight, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(page.description!, textAlign: TextAlign.center, maxLines: 2, style: bodyStyle),
            ],
          ),
        );
      },
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

  Widget _buildBackgroundDottoText() {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: const Offset(-42, 132),
          child: RotatedBox(
            quarterTurns: 1,
            child: Text(
              'Dotto',
              style: TextStyle(
                fontSize: 170,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
                color: SemanticColor.light.accentPrimary.withValues(alpha: 0.09),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dottoの使い方')),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildBackgroundDottoText()),
            Column(
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
