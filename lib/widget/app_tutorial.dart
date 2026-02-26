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
    _TutorialPageData(title: '時間割の管理', description: '自分の時間割を設定して\n休講/補講情報を受け取ろう', imagePath: Asset.tutorialHome),
    _TutorialPageData(title: 'バスの時刻表', description: '大学から最寄りのバス停までの\n時刻表を確認しよう', imagePath: Asset.tutorialMap),
    _TutorialPageData(title: '学内マップ', description: '空き教室を確認したり\n研究室を検索しよう', imagePath: Asset.tutorialMap),
    _TutorialPageData(title: '科目検索', description: 'レビューや過去問を\n閲覧しよう', imagePath: Asset.tutorialKamoku),
    _TutorialPageData(title: '課題の管理', description: 'HOPEと連携して\n課題をまとめて管理しよう', imagePath: Asset.tutorialKadai),
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
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Text(page.welcomeTitle!, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(Asset.icon1024, width: 140, height: 140),
          ),
          const SizedBox(height: 120),
          Text(page.welcomeBodyTop!, style: Theme.of(context).textTheme.displaySmall),
          Text(page.welcomeBodyBottom!, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildFeaturePage(BuildContext context, _TutorialPageData page) {
    final imageBackground = SemanticColor.accentMaterialColor.shade50;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
      child: Column(
        children: [
          Text(page.title!, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 430,
            decoration: BoxDecoration(color: imageBackground, borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 390),
                decoration: BoxDecoration(
                  color: SemanticColor.light.backgroundSecondary,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: SemanticColor.light.borderPrimary),
                  boxShadow: [
                    BoxShadow(
                      color: SemanticColor.light.backgroundQuaternary.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: AspectRatio(
                      aspectRatio: 1080 / 2130,
                      child: Image.asset(page.imagePath!, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(page.description!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
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
    this.welcomeTitle,
    this.welcomeBodyTop,
    this.welcomeBodyBottom,
  });

  final String? title;
  final String? description;
  final String? imagePath;
  final String? welcomeTitle;
  final String? welcomeBodyTop;
  final String? welcomeBodyBottom;

  bool get isWelcome => welcomeTitle != null;
}
