import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/haptics.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 58,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
    this.enableHaptics = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticLabel;
  final bool enableHaptics;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool value) {
    if (!_enabled) return;
    setState(() => _pressed = value);
  }

  Future<void> _handleTap() async {
    if (!_enabled) return;
    if (widget.enableHaptics) {
      await AppHaptics.medium();
    }
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final foreground = widget.foregroundColor ?? Colors.white;
    final disabled = !_enabled;

    final button = Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel ?? widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: _pressed ? 0.975 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: disabled ? 0.55 : 1,
            duration: const Duration(milliseconds: 160),
            child: Container(
              height: widget.height,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: widget.backgroundColor,
                gradient: widget.backgroundColor == null
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.primarySoft],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.24),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: widget.isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Row(
                          key: const ValueKey('button-label'),
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: foreground, size: 18),
                              const SizedBox(width: 9),
                            ],
                            Text(
                              widget.label,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: foreground,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!widget.isExpanded) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
