import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/style_preset_card.dart';

class StylePresetGrid extends StatelessWidget {
  const StylePresetGrid({
    super.key,
    required this.selectedPreset,
    required this.onSelected,
  });

  final String selectedPreset;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppConstants.stylePresets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.28,
      ),
      itemBuilder: (context, index) {
        final preset = AppConstants.stylePresets[index];
        return StylePresetCard(
          preset: preset,
          isSelected: selectedPreset == preset,
          onTap: () => onSelected(preset),
        );
      },
    );
  }
}
