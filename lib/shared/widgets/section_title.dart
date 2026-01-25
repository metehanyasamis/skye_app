import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Reusable section title widget
/// Displays "Top X around you" pattern with highlighted text
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.prefix,
    required this.highlighted,
    required this.suffix,
    this.highlightColor = const Color(0xFF007BA7),
  });

  final String prefix;
  final String highlighted;
  final String suffix;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
          children: [
            TextSpan(text: prefix),
            TextSpan(
              text: highlighted,
              style: TextStyle(color: highlightColor),
            ),
            TextSpan(text: suffix),
          ],
        ),
      ),
    );
  }
}
