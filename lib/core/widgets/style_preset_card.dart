import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

class StylePresetCard extends StatelessWidget {
  const StylePresetCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final String preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _accentForPreset(preset);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$preset style preset',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: isDark ? Colors.white.withOpacity(0.062) : Colors.white.withOpacity(0.86),
            border: Border.all(
              color: isSelected ? accent.withOpacity(0.75) : Colors.white.withOpacity(isDark ? 0.08 : 0.45),
              width: isSelected ? 1.35 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: accent.withOpacity(0.22),
                  blurRadius: 26,
                  offset: const Offset(0, 14),
                ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent.withOpacity(isSelected ? 0.24 : 0.13), Colors.white.withOpacity(isDark ? 0.025 : 0.58)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.18),
                    ),
                    child: Icon(iconForPreset(preset), size: 18, color: accent),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? accent : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? accent : AppColors.mutedFor(context).withOpacity(0.35),
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                        : null,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                preset,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 3),
              Text(
                _descriptionForPreset(preset),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _accentForPreset(String value) {
    switch (value) {
      case 'SaaS':
        return const Color(0xFF7C9BFF);
      case 'Gaming':
        return const Color(0xFF8C5CFF);
      case 'Luxury':
        return const Color(0xFFD7A955);
      case 'Portfolio':
        return const Color(0xFF55D1C6);
      case 'E-commerce':
        return const Color(0xFFFF7A45);
      case 'Glassmorphism':
        return const Color(0xFF86E7FF);
      case 'Dark Futuristic':
        return AppColors.primary;
      case 'Minimal':
      default:
        return const Color(0xFFB7B7B7);
    }
  }

  String _descriptionForPreset(String value) {
    switch (value) {
      case 'SaaS':
        return 'Clean product UI';
      case 'Gaming':
        return 'Electric and bold';
      case 'Luxury':
        return 'Editorial polish';
      case 'Portfolio':
        return 'Creator-focused';
      case 'E-commerce':
        return 'Conversion-led';
      case 'Glassmorphism':
        return 'Soft translucent depth';
      case 'Dark Futuristic':
        return 'Cinematic contrast';
      case 'Minimal':
      default:
        return 'Quiet and spacious';
    }
  }
}
