import 'package:dotto/asset.dart';
import 'package:dotto/feature/onboarding/domain/onboarding_page.dart';
import 'package:dotto_design_system/component/button.dart';
import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final class OnboardingScreen extends HookWidget {
  const OnboardingScreen({required this.onDismissed, super.key});

  final void Function() onDismissed;

  Widget _buildTopBar(BuildContext context, {required bool visible}) {
    return IgnorePointer(
      ignoring: !visible,
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 24, 40, 24),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset(Asset.icon, width: 52, height: 52)),
              const Spacer(),
              DottoButton(
                onPressed: onDismissed,
                type: DottoButtonType.text,
                style: DottoButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                ),
                child: const Text('スキップ'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage(BuildContext context, OnboardingWelcomePage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight > 40 ? constraints.maxHeight - 40 : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  page.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: SemanticColor.light.accentPrimary),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(Asset.icon, width: 140, height: 140),
                ),
                const SizedBox(height: 110),
                Text(
                  page.bodyTop,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: SemanticColor.light.labelPrimary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  page.bodyBottom,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: SemanticColor.light.labelPrimary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturePage(BuildContext context, OnboardingContentPage page) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bodyStyle = Theme.of(context).textTheme.bodyLarge;
        final titleStyle = Theme.of(context).textTheme.titleLarge;
        final estimatedTitleHeight = (titleStyle?.fontSize ?? 28) * (titleStyle?.height ?? 1.1);
        final estimatedDescriptionHeight = ((bodyStyle?.fontSize ?? 16) * (bodyStyle?.height ?? 1.4) * 2);
        const horizontalPadding = 0.0;
        const topPadding = 0.0;
        const bottomPadding = 0.0;
        const titleToImageSpacing = 14.0;
        const imageToDescriptionSpacing = 12.0;
        const topAndBottomSpacing = topPadding + bottomPadding + titleToImageSpacing + imageToDescriptionSpacing;
        final availableImageHeight =
            (constraints.maxHeight - topAndBottomSpacing - estimatedTitleHeight - estimatedDescriptionHeight).clamp(
              0.0,
              680.0,
            );

        const imageAspectRatio = 2130 / 1080;
        const visibleTopRatio = 0.7;
        final contentWidth = constraints.maxWidth - (horizontalPadding * 2);
        const desiredImageWidthFactor = 1.0;
        final maxWidthFactorForTop70 = (availableImageHeight / (contentWidth * imageAspectRatio * visibleTopRatio))
            .clamp(0.0, 1.0);
        final imageWidthFactor = desiredImageWidthFactor <= maxWidthFactorForTop70
            ? desiredImageWidthFactor
            : maxWidthFactorForTop70;
        final imageViewportHeight = contentWidth * imageWidthFactor * imageAspectRatio * visibleTopRatio;

        return Column(
          children: [
            Text(
              page.title,
              style: titleStyle?.copyWith(
                color: SemanticColor.light.accentPrimary,
                fontWeight: FontWeight.w600,
                fontSize: (titleStyle.fontSize ?? 24) - 2,
              ),
            ),
            const SizedBox(height: titleToImageSpacing),
            SizedBox(
              width: double.infinity,
              height: imageViewportHeight,
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: imageWidthFactor,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      page.imagePath,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                      errorBuilder: (_, _, _) =>
                          Image.asset(Asset.noImage, fit: BoxFit.fitWidth, alignment: Alignment.topCenter),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: imageToDescriptionSpacing),
            Text(
              page.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: bodyStyle,
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomArea({required int activeIndicatorIndex, required VoidCallback onNextButtonTapped}) {
    final indicatorCount = OnboardingPage.pages.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(indicatorCount, (index) {
              final isReached = index <= activeIndicatorIndex;
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isReached ? SemanticColor.light.accentPrimary : SemanticColor.light.borderPrimary,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: DottoButton(
              onPressed: onNextButtonTapped,
              child: Text(activeIndicatorIndex == indicatorCount ? 'はじめる' : '次へ'),
            ),
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
          offset: const Offset(-90, 132),
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
    final pageController = usePageController();
    final currentPage = useState(0);

    return Scaffold(
      appBar: AppBar(title: const Text('Dottoの使い方')),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(child: _buildBackgroundDottoText()),
            Column(
              children: [
                _buildTopBar(context, visible: currentPage.value != 0),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) => currentPage.value = index,
                    itemCount: OnboardingPage.pages.length,
                    itemBuilder: (context, index) {
                      final page = OnboardingPage.pages[index];
                      if (page is OnboardingWelcomePage) {
                        return _buildWelcomePage(context, page);
                      } else if (page is OnboardingContentPage) {
                        return _buildFeaturePage(context, page);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                _buildBottomArea(
                  activeIndicatorIndex: currentPage.value == 0 ? -1 : currentPage.value - 1,
                  onNextButtonTapped: () async {
                    if (currentPage.value == OnboardingPage.pages.length - 1) {
                      onDismissed();
                      return;
                    }
                    await pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
