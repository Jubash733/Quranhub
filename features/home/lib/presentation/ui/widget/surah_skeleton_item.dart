import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/widgets/skeleton.dart';

class SurahSkeletonItem extends StatelessWidget {
  final bool isDarkTheme;

  const SurahSkeletonItem({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    final baseColor =
        isDarkTheme ? kDarkPurple.withValues(alpha: 0.7) : kGrey92;
    final highlightColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: isDarkTheme ? kDarkPurple.withValues(alpha: 0.4) : Colors.white,
          border: Border.all(
            color: isDarkTheme
                ? Colors.white.withValues(alpha: 0.08)
                : kGrey.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            SkeletonBox(
              height: 42,
              width: 42,
              borderRadius: BorderRadius.circular(12.0),
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 14,
                    width: 140,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(height: 8.0),
                  SkeletonBox(
                    height: 12,
                    width: 120,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(height: 10.0),
                  SkeletonBox(
                    height: 10,
                    width: 160,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            SkeletonBox(
              height: 18,
              width: 18,
              borderRadius: BorderRadius.circular(6.0),
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
          ],
        ),
      ),
    );
  }
}
