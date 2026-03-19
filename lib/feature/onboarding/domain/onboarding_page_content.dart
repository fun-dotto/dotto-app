final class OnboardingPageContent {
  const OnboardingPageContent({
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
