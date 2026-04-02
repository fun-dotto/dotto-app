import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:dotto_design_system/style/text_style.dart';
import 'package:flutter/material.dart';

final class DottoTheme {
  static ThemeData get v2 {
    return ThemeData(
      useMaterial3: true,
      splashColor: SemanticColor.light.accentPrimary.withValues(alpha: 0.2),
      highlightColor: SemanticColor.light.accentPrimary.withValues(alpha: 0.12),
      colorScheme: ColorScheme.light(
        primary: SemanticColor.light.accentPrimary,
        surface: SemanticColor.light.backgroundPrimary,
        onSurface: SemanticColor.light.labelPrimary,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        titleTextStyle: DottoTextStyle.titleMedium.copyWith(
          color: SemanticColor.light.accentPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SemanticColor.light.accentPrimary.withValues(
          alpha: 0.08,
        ),
        indicatorColor: SemanticColor.light.accentPrimary.withValues(
          alpha: 0.12,
        ),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300),
      extensions: [SemanticColor.light],
      textTheme: const TextTheme(
        displayLarge: DottoTextStyle.displayLarge,
        displayMedium: DottoTextStyle.displayMedium,
        displaySmall: DottoTextStyle.displaySmall,
        headlineLarge: DottoTextStyle.headlineLarge,
        headlineMedium: DottoTextStyle.headlineMedium,
        headlineSmall: DottoTextStyle.headlineSmall,
        titleLarge: DottoTextStyle.titleLarge,
        titleMedium: DottoTextStyle.titleMedium,
        titleSmall: DottoTextStyle.titleSmall,
        bodyLarge: DottoTextStyle.bodyLarge,
        bodyMedium: DottoTextStyle.bodyMedium,
        bodySmall: DottoTextStyle.bodySmall,
        labelLarge: DottoTextStyle.labelLarge,
        labelMedium: DottoTextStyle.labelMedium,
        labelSmall: DottoTextStyle.labelSmall,
      ),
    );
  }
}
