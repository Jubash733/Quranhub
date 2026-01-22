import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:resources/styles/color.dart';
import 'package:resources/styles/text_styles.dart';

Color? statusColor(status) => status == 'success'
    ? Colors.green[600]
    : status == 'failed'
        ? Colors.red[600]
        : Colors.blue[600];

class CustomFlashWidget extends StatelessWidget {
  final String status;
  final FlashController controller;
  final String title;
  final String message;
  final bool darkTheme;
  final bool positionBottom;

  const CustomFlashWidget({
    super.key,
    required this.status,
    required this.controller,
    required this.title,
    required this.message,
    required this.darkTheme,
    required this.positionBottom,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor =
        darkTheme ? kPurplePrimary : (statusColor(status.toLowerCase()) ?? kPurplePrimary);
    final gradient = darkTheme
        ? const LinearGradient(
            colors: [
              kDarkPurple,
              kDarkTheme,
              kDarkTheme,
            ],
          )
        : const LinearGradient(
            colors: [
              Colors.white,
              kGrey92,
            ],
          );

    return FlashBar(
      controller: controller,
      behavior: FlashBehavior.floating,
      position: positionBottom ? FlashPosition.bottom : FlashPosition.top,
      forwardAnimationCurve: Curves.easeInCirc,
      reverseAnimationCurve: Curves.easeOutBack,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: accentColor),
        ),
        child: child,
      ),
      title: Text(
        title,
        style: kHeading5.copyWith(
          color: darkTheme ? kGrey92 : accentColor,
          fontSize: 16,
        ),
      ),
      content: Text(
        message,
        style: kHeading5.copyWith(
          color: darkTheme ? kGrey92 : accentColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      indicatorColor: accentColor,
      icon: Icon(
        status.toLowerCase() == 'success'
            ? Icons.check_circle
            : status == 'failed'
                ? Icons.warning_rounded
                : Icons.info,
        color: darkTheme ? Colors.white : accentColor,
      ),
      primaryAction: TextButton(
        onPressed: () => controller.dismiss(),
        child: Text(
          'TUTUP',
          style: kHeading5.copyWith(
            color: darkTheme ? kGrey92 : accentColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
