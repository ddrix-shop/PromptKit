import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onActionTap != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onActionTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 2),
                child: Text(
                  actionLabel!,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
