import 'package:dotto_design_system/style/semantic_color.dart';
import 'package:flutter/material.dart';

final class QuickButton extends StatelessWidget {
  const QuickButton({
    required this.iconUrl,
    required this.fallbackIcon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String? iconUrl;
  final IconData fallbackIcon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            if (iconUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  iconUrl!,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    fallbackIcon,
                    size: 24,
                    color: SemanticColor.light.labelPrimary,
                  ),
                ),
              )
            else
              Icon(
                fallbackIcon,
                size: 24,
                color: SemanticColor.light.labelPrimary,
              ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
