import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/style_preset_card.dart';

Future<void> showStylePresetBottomSheet({
  required BuildContext context,
  required String selectedPreset,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.90,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Choose a visual style', style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SliverGrid.builder(
                  itemCount: AppConstants.stylePresets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final preset = AppConstants.stylePresets[index];
                    return StylePresetCard(
                      preset: preset,
                      isSelected: selectedPreset == preset,
                      onTap: () {
                        onSelected(preset);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
