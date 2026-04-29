import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/snackbars.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/loading_generation_view.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../core/widgets/section_header.dart';
import '../../providers/app_providers.dart';
import 'widgets/component_type_chips.dart';
import 'widgets/generation_options.dart';
import 'widgets/prompt_input_card.dart';
import 'widgets/style_preset_bottom_sheet.dart';
import 'widgets/style_preset_grid.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  late final TextEditingController _promptController;

  @override
  void initState() {
    super.initState();
    final initialPrompt = ref.read(generatorControllerProvider).prompt;
    _promptController = TextEditingController(text: initialPrompt);
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    FocusScope.of(context).unfocus();
    final component = await ref.read(generatorControllerProvider.notifier).generate();
    final error = ref.read(generatorControllerProvider).errorMessage;

    if (!mounted) return;
    if (component != null) {
      context.push('/result', extra: component);
    } else if (error != null) {
      showCraftSnack(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generatorControllerProvider);
    final controller = ref.read(generatorControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.82, -0.92),
            radius: 1.2,
            colors: [AppColors.primary.withOpacity(0.20), Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
            stops: const [0, 0.38, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: AnimatedPageWrapper(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  sliver: SliverList.list(
                    children: [
                      _GeneratorHeader(
                        onSavedTap: () => context.push('/saved'),
                        onSettingsTap: () => context.push('/settings'),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'What do you want to build?',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Describe a component, pick a style direction, and preview clean mobile-first HTML/CSS.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.mutedFor(context),
                            ),
                      ),
                      const SizedBox(height: 22),
                      PromptInputCard(
                        controller: _promptController,
                        onChanged: controller.setPrompt,
                        onUseExample: () {
                          _promptController.text = AppConstants.samplePrompt;
                          controller.setPrompt(AppConstants.samplePrompt);
                          _promptController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _promptController.text.length),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Component type'),
                      ComponentTypeChips(
                        selectedType: state.componentType,
                        onSelected: controller.setComponentType,
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(
                        title: 'Visual style',
                        subtitle: state.stylePreset,
                        actionLabel: 'Browse',
                        onActionTap: () => showStylePresetBottomSheet(
                          context: context,
                          selectedPreset: state.stylePreset,
                          onSelected: controller.setStylePreset,
                        ),
                      ),
                      StylePresetGrid(
                        selectedPreset: state.stylePreset,
                        onSelected: controller.setStylePreset,
                      ),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Advanced options'),
                      GenerationOptions(
                        includeResponsive: state.includeResponsive,
                        includeAnimations: state.includeAnimations,
                        useCssVariables: state.useCssVariables,
                        oneFileHtml: state.oneFileHtml,
                        onIncludeResponsiveChanged: controller.setIncludeResponsive,
                        onIncludeAnimationsChanged: controller.setIncludeAnimations,
                        onUseCssVariablesChanged: controller.setUseCssVariables,
                        onOneFileHtmlChanged: controller.setOneFileHtml,
                      ),
                      const SizedBox(height: 20),
                      if (state.isGenerating) ...[
                        LoadingGenerationView(currentStep: state.loadingStep)
                            .animate()
                            .fadeIn(duration: 240.ms)
                            .moveY(begin: 12, end: 0),
                        const SizedBox(height: 18),
                      ],
                      PremiumButton(
                        label: 'Generate Component',
                        icon: CupertinoIcons.sparkles,
                        isLoading: state.isGenerating,
                        onPressed: state.isGenerating ? null : _generate,
                        semanticLabel: 'Generate HTML and CSS component',
                      ),
                      SizedBox(height: MediaQuery.paddingOf(context).bottom + 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: state.isGenerating ? 0 : 1,
        duration: const Duration(milliseconds: 180),
        child: FloatingActionButton.small(
          elevation: 0,
          backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
          foregroundColor: AppColors.textFor(context),
          onPressed: () => context.push('/saved'),
          child: const Icon(CupertinoIcons.bookmark_fill, size: 18),
        ),
      ),
    );
  }
}

class _GeneratorHeader extends StatelessWidget {
  const _GeneratorHeader({required this.onSavedTap, required this.onSettingsTap});

  final VoidCallback onSavedTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          borderRadius: 999,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primarySoft]),
                ),
                child: const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 15),
              ),
              const SizedBox(width: 9),
              Text('CraftUI', style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
        const Spacer(),
        PremiumIconButton(
          icon: CupertinoIcons.bookmark,
          onPressed: onSavedTap,
          semanticLabel: 'Open saved components',
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: CupertinoIcons.gear_alt,
          onPressed: onSettingsTap,
          semanticLabel: 'Open settings',
        ),
      ],
    );
  }
}
