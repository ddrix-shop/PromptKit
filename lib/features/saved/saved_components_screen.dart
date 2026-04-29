import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/snackbars.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../data/models/generated_component.dart';
import '../../providers/app_providers.dart';

class SavedComponentsScreen extends ConsumerWidget {
  const SavedComponentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedState = ref.watch(savedComponentsProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnimatedPageWrapper(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
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
                              Text('Saved Components', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 3),
                              Text('Your reusable HTML/CSS library', style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                        PremiumIconButton(
                          icon: CupertinoIcons.arrow_clockwise,
                          onPressed: () => ref.read(savedComponentsProvider.notifier).load(),
                          semanticLabel: 'Refresh saved components',
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text('Saved work', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 10),
                    Text(
                      'Open, copy, export, or delete your generated UI components.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
              savedState.when(
                data: (components) {
                  if (components.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                        child: Center(
                          child: EmptyState(
                            icon: CupertinoIcons.bookmark,
                            title: 'No saved components yet',
                            message: 'Generate a component and tap Save to build your mobile UI library.',
                            actionLabel: 'Create component',
                            onAction: () => context.go('/home'),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.paddingOf(context).bottom + 24),
                    sliver: SliverList.separated(
                      itemCount: components.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final component = components[index];
                        return SavedComponentCard(
                          component: component,
                          onOpen: () {
                            ref.read(currentGeneratedComponentProvider.notifier).state = component;
                            context.push('/result', extra: component);
                          },
                          onCopy: () async {
                            await FlutterClipboard.copy(component.fullHtml);
                            if (context.mounted) showCraftSnack(context, 'Full code copied to clipboard.');
                          },
                          onDelete: () async {
                            final shouldDelete = await _confirmDelete(context);
                            if (shouldDelete == true) {
                              await ref.read(savedComponentsProvider.notifier).delete(component.id);
                              if (context.mounted) showCraftSnack(context, 'Component deleted.');
                            }
                          },
                        ).animate(delay: (index * 55).ms).fadeIn(duration: 320.ms).moveY(begin: 16, end: 0);
                      },
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CupertinoActivityIndicator(color: AppColors.primary)),
                ),
                error: (error, _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: EmptyState(
                        icon: CupertinoIcons.exclamationmark_triangle,
                        title: 'Could not load saved items',
                        message: 'Try refreshing your local component library.',
                        actionLabel: 'Refresh',
                        onAction: () => ref.read(savedComponentsProvider.notifier).load(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete component?'),
          content: const Text('This removes the saved component from local storage.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class SavedComponentCard extends StatelessWidget {
  const SavedComponentCard({
    super.key,
    required this.component,
    required this.onOpen,
    required this.onCopy,
    required this.onDelete,
  });

  final GeneratedComponent component;
  final VoidCallback onOpen;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('MMM d, y').format(component.createdAt);

    return GlassCard(
      padding: const EdgeInsets.all(14),
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PreviewThumb(stylePreset: component.stylePreset),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  '${component.componentType} • ${component.stylePreset}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Text(date, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primarySoft)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MiniAction(label: 'Open', icon: CupertinoIcons.arrow_up_right, onTap: onOpen),
                    const SizedBox(width: 8),
                    _MiniAction(label: 'Copy', icon: CupertinoIcons.doc_on_doc, onTap: onCopy),
                    const SizedBox(width: 8),
                    _MiniAction(label: 'Delete', icon: CupertinoIcons.trash, onTap: onDelete, destructive: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewThumb extends StatelessWidget {
  const _PreviewThumb({required this.stylePreset});

  final String stylePreset;

  @override
  Widget build(BuildContext context) {
    final accent = stylePreset == 'Luxury'
        ? const Color(0xFFD7A955)
        : stylePreset == 'Glassmorphism'
            ? const Color(0xFF86E7FF)
            : AppColors.primary;

    return Container(
      width: 86,
      height: 104,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent.withOpacity(0.30), Colors.white.withOpacity(0.06)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TinyDot(color: Colors.redAccent),
              const SizedBox(width: 4),
              _TinyDot(color: Colors.amber),
              const SizedBox(width: 4),
              _TinyDot(color: Colors.greenAccent),
            ],
          ),
          const Spacer(),
          Container(height: 9, width: 46, decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 7),
          Container(height: 7, width: 62, decoration: BoxDecoration(color: Colors.white.withOpacity(0.28), borderRadius: BorderRadius.circular(999))),
          const SizedBox(height: 5),
          Container(height: 7, width: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(999))),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Colors.redAccent : AppColors.textFor(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.06 : 0.62),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _TinyDot extends StatelessWidget {
  const _TinyDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
