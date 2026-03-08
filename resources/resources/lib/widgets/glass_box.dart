import 'package:flutter/material.dart';
import 'dart:ui';
import '../styles/color.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isDark;
  final VoidCallback? onTap;

  const GlassBox({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.isDark = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: isDark
                      ? kGlassBlack.withOpacity(0.6)
                      : kGlassWhite.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
