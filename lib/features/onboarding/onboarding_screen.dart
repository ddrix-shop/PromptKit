import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import '../../providers/app_providers.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.7, -0.72),
            radius: 1.2,
            colors: [AppColors.primary.withOpacity(0.28), Colors.transparent, isDark ? AppColors.darkBackground : AppColors.lightBackground],
            stops: const [0, 0.42, 1],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: AnimatedPageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primarySoft],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.32),
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                            ),
                          ],
                        ),
                        child: const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(AppConstants.appName, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'AI UI generation, built for your phone.',
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn(duration: 520.ms).moveY(begin: 18, end: 0),
                  const SizedBox(height: 18),
                  Text(
                    AppConstants.tagline,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.mutedFor(context),
                        ),
                  ),
                  const SizedBox(height: 26),
                  GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: const [
                        _OnboardingFeature(
                          icon: CupertinoIcons.command,
                          title: 'Prompt to component',
                          copy: 'Generate polished HTML and CSS from natural language.',
                        ),
                        SizedBox(height: 14),
                        _OnboardingFeature(
                          icon: CupertinoIcons.device_phone_portrait,
                          title: 'Live mobile preview',
                          copy: 'Inspect responsive components inside a native WebView.',
                        ),
                        SizedBox(height: 14),
                        _OnboardingFeature(
                          icon: CupertinoIcons.square_arrow_up,
                          title: 'Save, copy, export',
                          copy: 'Keep your best UI blocks and export one-file HTML.',
                        ),
                      ],
                    ),
                  ).animate(delay: 180.ms).fadeIn(duration: 500.ms).moveY(begin: 22, end: 0),
                  const Spacer(),
                  PremiumButton(
                    label: 'Start creating',
                    icon: CupertinoIcons.arrow_right,
                    semanticLabel: 'Start creating components',
                    onPressed: () async {
                      await ref.read(localStorageServiceProvider).setHasSeenOnboarding(true);
                      if (context.mounted) context.go('/home');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingFeature extends StatelessWidget {
  const _OnboardingFeature({required this.icon, required this.title, required this.copy});

  final IconData icon;
  final String title;
  final String copy;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.13),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 3),
              Text(copy, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
