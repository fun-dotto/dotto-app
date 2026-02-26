import 'package:dotto/asset.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class _TutorialPageData {
  const _TutorialPageData({required this.title, required this.body, this.imagePath, this.placeholder = false});

  final String title;
  final String body;
  final String? imagePath;
  final bool placeholder;
}

final class AppTutorial extends StatefulWidget {
  const AppTutorial({required this.onDismissed, super.key});

  final void Function() onDismissed;

  @override
  State<AppTutorial> createState() => _AppTutorialState();
}

final class _AppTutorialState extends State<AppTutorial> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const _pages = <_TutorialPageData>[
    _TutorialPageData(title: 'ようこそ', body: 'Dottoではこだて未来大学のすべてを'),
    _TutorialPageData(title: '時間割の管理', body: '自分の時間割を設定して\n休講/補講情報を受け取ろう', imagePath: Asset.tutorialHome),
    _TutorialPageData(title: 'バスの時刻表', body: '大学から最寄りのバス停までの\n時刻表を確認しよう', placeholder: true),
    _TutorialPageData(title: '学内マップ', body: '空き教室を確認したり\n研究室の検索しよう', imagePath: Asset.tutorialMap),
    _TutorialPageData(title: '科目検索', body: 'レビューや過去問を\n観覧しよう', imagePath: Asset.tutorialKamoku),
    _TutorialPageData(title: '課題の管理', body: 'HOPEと連携して\n課題をまとめて管理しよう', imagePath: Asset.tutorialKadai),
    _TutorialPageData(title: '学食メニュー', body: '空き教室を確認したり\n研究室の検索しよう', placeholder: true),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBackgroundWord(Color color) {
    return Positioned(
      left: -138,
      bottom: -16,
      child: RotatedBox(
        quarterTurns: 1,
        child: Text(
          'Dotto',
          style: TextStyle(color: color, fontSize: 240, fontWeight: FontWeight.w700, height: 1.2),
        ),
      ),
    );
  }

  Widget _buildIndicator(Color activeColor, Color inactiveColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final color = index == _currentPage ? activeColor : inactiveColor;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }),
    );
  }

  Widget _buildPageButton({required bool isLastPage, required Color accentPrimary}) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: accentPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: () {
          if (isLastPage) {
            widget.onDismissed();
            return;
          }
          _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
        },
        child: Text(isLastPage ? 'はじめよう' : '次へ'),
      ),
    );
  }

  Widget _buildFirstPage(
    BuildContext context,
    _TutorialPageData page,
    Color accentPrimary,
    Color labelPrimary,
    Color inactiveDot,
  ) {
    final boldStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(color: accentPrimary, fontWeight: FontWeight.w700, letterSpacing: 0.96);

    return Column(
      children: [
        const Spacer(flex: 2),
        Text(
          page.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: accentPrimary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        SizedBox(width: 140, height: 140, child: Image.asset(Asset.icon768, fit: BoxFit.cover)),
        const SizedBox(height: 120),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: labelPrimary),
            children: [
              TextSpan(text: 'Dotto', style: boldStyle),
              const TextSpan(text: 'で'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'はこだて未来大学のすべてを',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: labelPrimary),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 3),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              _buildIndicator(accentPrimary, inactiveDot),
              const SizedBox(height: 8),
              _buildPageButton(isLastPage: false, accentPrimary: accentPrimary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturePage(
    BuildContext context,
    _TutorialPageData page,
    Color accentPrimary,
    Color labelSecondary,
    Color borderPrimary,
    Color inactiveDot,
    bool isLastPage,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 24, 40, 0),
          child: Row(
            children: [
              SizedBox(width: 61, height: 61, child: Image.asset(Asset.icon768, fit: BoxFit.cover)),
              const Spacer(),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderPrimary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: widget.onDismissed,
                  child: const Text('スキップ'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 49),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text(
                page.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: accentPrimary, fontWeight: FontWeight.w700, fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  width: 326,
                  height: 320,
                  child: page.placeholder
                      ? Container(color: borderPrimary)
                      : Image.asset(page.imagePath!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                page.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: labelSecondary, height: 1.8),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              _buildIndicator(accentPrimary, inactiveDot),
              const SizedBox(height: 8),
              _buildPageButton(isLastPage: isLastPage, accentPrimary: accentPrimary),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentPrimary = SemanticColor.light.accentPrimary;
    final labelPrimary = SemanticColor.light.labelPrimary;
    final labelSecondary = SemanticColor.light.labelSecondary;
    final borderPrimary = SemanticColor.light.borderPrimary;
    final backgroundSecondary = SemanticColor.light.backgroundSecondary;
    final backgroundWordColor = accentPrimary.withValues(alpha: 0.1);
    final inactiveDot = borderPrimary;

    return Scaffold(
      backgroundColor: backgroundSecondary,
      body: SafeArea(
        child: Stack(
          children: [
            _buildBackgroundWord(backgroundWordColor),
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];
                if (index == 0) {
                  return _buildFirstPage(context, page, accentPrimary, labelPrimary, inactiveDot);
                }
                return _buildFeaturePage(
                  context,
                  page,
                  accentPrimary,
                  labelSecondary,
                  borderPrimary,
                  inactiveDot,
                  index == _pages.length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
