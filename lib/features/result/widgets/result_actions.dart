import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class ResultActions extends StatelessWidget {
  const ResultActions({
    super.key,
    required this.onCopy,
    required this.onSave,
    required this.onExport,
    required this.isSaved,
  });

  final VoidCallback onCopy;
  final VoidCallback onSave;
  final VoidCallback onExport;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _ActionItem(
            icon: CupertinoIcons.doc_on_doc,
            label: 'Copy',
            onTap: onCopy,
          ),
          _ActionItem(
            icon: isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
            label: isSaved ? 'Saved' : 'Save',
            onTap: onSave,
          ),
          _ActionItem(
            icon: CupertinoIcons.square_arrow_up,
            label: 'Export',
            onTap: onExport,
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.03 : 0.42),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 19, color: AppColors.textFor(context)),
                const SizedBox(height: 4),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
