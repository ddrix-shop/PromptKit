import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedPageWrapper extends StatelessWidget {
  const AnimatedPageWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: 420.ms, curve: Curves.easeOutCubic)
        .moveY(begin: 18, end: 0, duration: 420.ms, curve: Curves.easeOutCubic);
  }
}
