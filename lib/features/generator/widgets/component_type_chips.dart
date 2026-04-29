import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/component_type_chip.dart';

class ComponentTypeChips extends StatelessWidget {
  const ComponentTypeChips({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  final String selectedType;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.componentTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final type = AppConstants.componentTypes[index];
          return ComponentTypeChip(
            label: type,
            isSelected: selectedType == type,
            onTap: () => onSelected(type),
          );
        },
      ),
    );
  }
}
