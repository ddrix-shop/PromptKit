import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class GenerationOptions extends StatelessWidget {
  const GenerationOptions({
    super.key,
    required this.includeResponsive,
    required this.includeAnimations,
    required this.useCssVariables,
    required this.oneFileHtml,
    required this.onIncludeResponsiveChanged,
    required this.onIncludeAnimationsChanged,
    required this.onUseCssVariablesChanged,
    required this.onOneFileHtmlChanged,
  });

  final bool includeResponsive;
  final bool includeAnimations;
  final bool useCssVariables;
  final bool oneFileHtml;
  final ValueChanged<bool> onIncludeResponsiveChanged;
  final ValueChanged<bool> onIncludeAnimationsChanged;
  final ValueChanged<bool> onUseCssVariablesChanged;
  final ValueChanged<bool> onOneFileHtmlChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _OptionRow(
            icon: CupertinoIcons.device_phone_portrait,
            title: 'Include responsive CSS',
            subtitle: 'Mobile-first breakpoints and adaptive spacing.',
            value: includeResponsive,
            onChanged: onIncludeResponsiveChanged,
          ),
          _OptionRow(
            icon: CupertinoIcons.wand_stars,
            title: 'Include animations',
            subtitle: 'Subtle keyframes and hover motion.',
            value: includeAnimations,
            onChanged: onIncludeAnimationsChanged,
          ),
          _OptionRow(
            icon: CupertinoIcons.slider_horizontal_3,
            title: 'Use CSS variables',
            subtitle: 'Tokenized color, radius, shadow, and spacing.',
            value: useCssVariables,
            onChanged: onUseCssVariablesChanged,
          ),
          _OptionRow(
            icon: CupertinoIcons.doc_fill,
            title: 'One-file HTML',
            subtitle: 'Prepare a self-contained export document.',
            value: oneFileHtml,
            onChanged: onOneFileHtmlChanged,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
