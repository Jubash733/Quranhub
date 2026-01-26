import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

class StateMessage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final bool isDarkTheme;
  final String? actionLabel;
  final VoidCallback? onAction;

  const StateMessage({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.isDarkTheme,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkTheme ? Colors.white : kDarkPurple;
    final messageColor = isDarkTheme
        ? Colors.white70
        : kDarkPurple.withValues(alpha: 0.7);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: isDarkTheme ? kLinearPurple1 : kPurplePrimary,
            ),
            const SizedBox(height: 12.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: kHeading6.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              message,
              textAlign: TextAlign.center,
              style: kSubtitle.copyWith(color: messageColor),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16.0),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDarkTheme ? kLinearPurple2 : kPurplePrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
