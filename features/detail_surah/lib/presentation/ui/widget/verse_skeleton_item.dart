import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/widgets/skeleton.dart';

class VerseSkeletonItem extends StatelessWidget {
  final bool isDarkTheme;

  const VerseSkeletonItem({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    final baseColor =
        isDarkTheme ? kDarkPurple.withValues(alpha: 0.7) : kGrey92;
    final highlightColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13.0),
            decoration: BoxDecoration(
              color: kPurplePrimary.withValues(alpha: 0.065),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Row(
              children: [
                SkeletonBox(
                  height: 35,
                  width: 35,
                  borderRadius: BorderRadius.circular(100.0),
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const Spacer(),
                SkeletonBox(
                  height: 18,
                  width: 18,
                  borderRadius: BorderRadius.circular(6.0),
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(width: 12.0),
                SkeletonBox(
                  height: 18,
                  width: 18,
                  borderRadius: BorderRadius.circular(6.0),
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
                const SizedBox(width: 6.0),
              ],
            ),
          ),
          const SizedBox(height: 14.0),
          Align(
            alignment: Alignment.centerRight,
            child: SkeletonBox(
              height: 20,
              width: 220,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
          ),
          const SizedBox(height: 10.0),
          SkeletonBox(
            height: 12,
            width: 260,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
        ],
      ),
    );
  }
}
