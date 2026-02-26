import 'package:dotto/asset.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class AppTutorial extends StatefulWidget {
  const AppTutorial({required this.onDismissed, super.key});

  final void Function() onDismissed;

  @override
  State<AppTutorial> createState() => _AppTutorialState();
}

final class _AppTutorialState extends State<AppTutorial> {
  late final PageController _pageController;
  int _currentPage = 0;

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

  Widget _withImage(
    BuildContext context,
    double topMargin,
    String imagePath,
    String title,
    String body,
    Color backgroundColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: backgroundColor,
              image: DecorationImage(
                image: AssetImage(imagePath),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            // ②Containerを重ねる
            child: Container(
              decoration: BoxDecoration(
                // ③グラデーション
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: const Alignment(0, 0.4),
                  // ④透明→白
                  colors: [Colors.transparent, backgroundColor],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: topMargin),
            child: Column(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = MediaQuery.of(context).size.height / 2;
    final backgroundColor = SemanticColor.accentMaterialColor.shade50;
    final pages = <Widget>[
      _withImage(context, topMargin, Asset.tutorialHome, 'ホーム', '時間割を設定でき、休講・補講情報などの確認をできます', backgroundColor),
      _withImage(context, topMargin, Asset.tutorialMap, '学内マップ', '使用中の教室を確認したり、教員名で検索したりできます', backgroundColor),
      _withImage(context, topMargin, Asset.tutorialKamoku, '科目検索', 'シラバスから科目を検索できます', backgroundColor),
      _withImage(context, topMargin, Asset.tutorialKadai, 'HOPE課題', 'HOPEで設定を行うことで課題を表示することができます', backgroundColor),
      Container(
        color: SemanticColor.accentMaterialColor.shade100,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 25),
        child: Text('さあ、始めましょう！', style: Theme.of(context).textTheme.headlineMedium),
      ),
    ];

    final isLastPage = _currentPage == pages.length - 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Dottoの使い方')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) => pages[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPage ? Colors.black : Colors.black38,
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  TextButton(onPressed: widget.onDismissed, child: const Text('閉じる')),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (isLastPage) {
                        widget.onDismissed();
                        return;
                      }
                      _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                    },
                    child: Text(isLastPage ? '閉じる' : 'つぎへ'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
