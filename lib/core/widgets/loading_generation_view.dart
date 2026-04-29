import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import 'glass_card.dart';

class LoadingGenerationView extends StatelessWidget {
  const LoadingGenerationView({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / AppConstants.loadingSteps.length;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.14),
                ),
                child: const CupertinoActivityIndicator(color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Generating component', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text('Crafting responsive HTML and CSS.', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  minHeight: 8,
                  value: value,
                  backgroundColor: Colors.white.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(AppConstants.loadingSteps.length, (index) {
            final active = index <= currentStep;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? AppColors.primary : Colors.white.withOpacity(0.07),
                    ),
                    child: active
                        ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppConstants.loadingSteps[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: active ? AppColors.textFor(context) : AppColors.mutedFor(context),
                          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                        ),
                  ),
                ],
              ).animate(delay: (index * 80).ms).fadeIn(duration: 260.ms).moveX(begin: -8, end: 0),
            );
          }),
        ],
      ),
    );
  }
}
