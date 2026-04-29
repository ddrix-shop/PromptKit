import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class ComponentTypeChip extends StatelessWidget {
  const ComponentTypeChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white.withOpacity(0.065) : Colors.white.withOpacity(0.80)),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.26),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                iconForComponentType(label),
                size: 15,
                color: isSelected ? Colors.white : AppColors.mutedFor(context),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected ? Colors.white : AppColors.textFor(context),
                      fontSize: 13,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
