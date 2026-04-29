import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../data/models/app_settings.dart';
import '../../providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedPageWrapper(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.paddingOf(context).bottom + 28),
                sliver: SliverList.list(
                  children: [
                    Row(
                      children: [
                        PremiumIconButton(
                          icon: CupertinoIcons.chevron_left,
                          onPressed: () => context.pop(),
                          semanticLabel: 'Back',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Settings', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 3),
                              Text('Defaults and future AI connection', style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text('Preferences', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 10),
                    Text(
                      'Tune the app behavior without sacrificing the premium mobile-first workflow.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    const SizedBox(height: 24),
                    _SettingsSection(
                      title: 'Theme',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _ChoicePill(
                            label: 'Dark',
                            selected: settings.themeMode == ThemeMode.dark,
                            onTap: () => controller.setThemeMode(ThemeMode.dark),
                          ),
                          _ChoicePill(
                            label: 'Light',
                            selected: settings.themeMode == ThemeMode.light,
                            onTap: () => controller.setThemeMode(ThemeMode.light),
                          ),
                          _ChoicePill(
                            label: 'System',
                            selected: settings.themeMode == ThemeMode.system,
                            onTap: () => controller.setThemeMode(ThemeMode.system),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SettingsSection(
                      title: 'Default style preset',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: AppConstants.stylePresets.map((preset) {
                          return _ChoicePill(
                            label: preset,
                            selected: settings.defaultStylePreset == preset,
                            onTap: () => controller.setDefaultStylePreset(preset),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SettingsSection(
                      title: 'Default output mode',
                      child: Column(
                        children: OutputMode.values.map((mode) {
                          final selected = settings.defaultOutputMode == mode;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _OptionTile(
                              icon: mode == OutputMode.separate ? CupertinoIcons.square_split_2x1 : CupertinoIcons.doc_fill,
                              title: mode.label,
                              subtitle: mode == OutputMode.separate
                                  ? 'Keep HTML and CSS separated in tabs.'
                                  : 'Prepare a self-contained export document.',
                              selected: selected,
                              onTap: () => controller.setDefaultOutputMode(mode),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SettingsSection(
                      title: 'AI service',
                      child: _ApiPlaceholder(),
                    ),
                    const SizedBox(height: 16),
                    _SettingsSection(
                      title: 'About',
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primarySoft]),
                            ),
                            child: const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 19),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppConstants.appName, style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 2),
                                Text('Version 1.0.0', style: Theme.of(context).textTheme.labelMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected ? AppColors.primary : Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.06 : 0.72),
          border: Border.all(
            color: selected ? AppColors.primary : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? Colors.white : AppColors.textFor(context),
              ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 210),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: selected ? AppColors.primary.withOpacity(0.12) : Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.04 : 0.62),
          border: Border.all(
            color: selected ? AppColors.primary.withOpacity(0.75) : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.mutedFor(context), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ApiPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.04 : 0.62),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.12),
            ),
            child: const Icon(CupertinoIcons.lock_fill, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('API key connection', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'The AI service layer is ready. Add your OpenAI or custom provider integration inside AiGenerationService when you are ready to go live.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.20 : 0.04),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'sk-••••••••••••••••••••',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Text('Coming soon', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primarySoft)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
