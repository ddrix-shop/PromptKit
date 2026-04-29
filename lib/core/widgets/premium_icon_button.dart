import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/haptics.dart';

class PremiumIconButton extends StatefulWidget {
  const PremiumIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = 46,
    this.iconSize = 20,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<PremiumIconButton> createState() => _PremiumIconButtonState();
}

class _PremiumIconButtonState extends State<PremiumIconButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  Future<void> _handleTap() async {
    if (!_enabled) return;
    await AppHaptics.light();
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      enabled: _enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOutCubic,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor ??
                  (isDark ? Colors.white.withOpacity(0.08) : Colors.white.withOpacity(0.84)),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.18 : 0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: widget.foregroundColor ?? AppColors.textFor(context),
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
