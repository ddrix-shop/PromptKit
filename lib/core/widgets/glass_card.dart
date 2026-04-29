import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.borderRadius = 24,
    this.width,
    this.height,
    this.opacity,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double? width;
  final double? height;
  final double? opacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseOpacity = opacity ?? (isDark ? 0.075 : 0.72);
    final borderColor = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: (isDark ? Colors.white : Colors.white).withOpacity(baseOpacity),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.20 : 0.05),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.white.withOpacity(0.095), Colors.white.withOpacity(0.035)]
                  : [Colors.white.withOpacity(0.92), AppColors.lightSurface.withOpacity(0.66)],
            ),
          ),
          child: child,
        ),
      ),
    );

    final content = margin == null ? card : Padding(padding: margin!, child: card);

    if (onTap == null) return content;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: content,
    );
  }
}
