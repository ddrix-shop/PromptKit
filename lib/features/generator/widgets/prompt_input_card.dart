import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glass_card.dart';

class PromptInputCard extends StatelessWidget {
  const PromptInputCard({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onUseExample,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onUseExample;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.text_alignleft, size: 18, color: AppColors.mutedFor(context)),
              const SizedBox(width: 8),
              Text('Prompt', style: Theme.of(context).textTheme.labelLarge),
              const Spacer(),
              GestureDetector(
                onTap: onUseExample,
                child: Text(
                  'Use example',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: onChanged,
            minLines: 4,
            maxLines: 7,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textFor(context),
                  height: 1.42,
                ),
            decoration: const InputDecoration(
              hintText: 'Describe your section, layout, style, colors, and content…',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.primary.withOpacity(0.08),
            ),
            child: Text(
              'Example: “${AppConstants.samplePrompt}”',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primarySoft),
            ),
          ),
        ],
      ),
    );
  }
}
