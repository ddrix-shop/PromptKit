import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/code_helpers.dart';
import '../../core/utils/haptics.dart';
import '../../core/utils/snackbars.dart';
import '../../core/widgets/animated_page_wrapper.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_button.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../data/models/generated_component.dart';
import '../../providers/app_providers.dart';
import '../code_viewer/code_viewer_screen.dart';
import 'widgets/code_viewer.dart';
import 'widgets/preview_webview.dart';
import 'widgets/result_actions.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, this.initialComponent});

  final GeneratedComponent? initialComponent;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  ResultTab _selectedTab = ResultTab.preview;
  GeneratedComponent? _localComponent;

  @override
  void initState() {
    super.initState();
    _localComponent = widget.initialComponent;
    if (widget.initialComponent != null) {
      Future.microtask(() {
        ref.read(currentGeneratedComponentProvider.notifier).state = widget.initialComponent;
      });
    }
  }

  GeneratedComponent? get _component => _localComponent ?? ref.watch(currentGeneratedComponentProvider);

  Future<void> _copyText(String value, String label) async {
    await FlutterClipboard.copy(value);
    await AppHaptics.success();
    if (mounted) showCraftSnack(context, '$label copied to clipboard.');
  }

  Future<void> _save(GeneratedComponent component) async {
    final saved = await ref.read(savedComponentsProvider.notifier).save(component);
    setState(() => _localComponent = saved);
    if (mounted) showCraftSnack(context, 'Component saved.');
  }

  Future<void> _export(GeneratedComponent component) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    await ref.read(exportServiceProvider).shareHtmlFile(
          component,
          sharePositionOrigin: origin,
        );
    if (mounted) showCraftSnack(context, 'One-file HTML export ready.');
  }

  void _showCopySheet(GeneratedComponent component) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Copy code', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _CopyRow(
                    icon: CupertinoIcons.chevron_left_slash_chevron_right,
                    title: 'Copy HTML',
                    onTap: () {
                      Navigator.pop(context);
                      _copyText(component.html, 'HTML');
                    },
                  ),
                  _CopyRow(
                    icon: CupertinoIcons.paintbrush,
                    title: 'Copy CSS',
                    onTap: () {
                      Navigator.pop(context);
                      _copyText(component.css, 'CSS');
                    },
                  ),
                  _CopyRow(
                    icon: CupertinoIcons.doc_text,
                    title: 'Copy full code',
                    onTap: () {
                      Navigator.pop(context);
                      _copyText(component.fullHtml, 'Full code');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final component = _component;

    if (component == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: EmptyState(
                title: 'No generated component',
                message: 'Create a new component to preview and export code.',
                actionLabel: 'Open generator',
                onAction: () => context.go('/home'),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.9, -0.88),
            radius: 1.22,
            colors: [AppColors.primary.withOpacity(0.16), Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
            stops: const [0, 0.42, 1],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: AnimatedPageWrapper(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 124),
                      sliver: SliverList.list(
                        children: [
                          _ResultHeader(
                            title: component.title,
                            subtitle: '${component.componentType} • ${component.stylePreset}',
                            onBack: () => context.pop(),
                            onPreview: () => context.push('/preview', extra: component),
                          ),
                          const SizedBox(height: 20),
                          _SegmentedTabs(
                            selected: _selectedTab,
                            onSelected: (tab) => setState(() => _selectedTab = tab),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 240),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeOutCubic,
                            child: _buildTabContent(component),
                          ),
                          const SizedBox(height: 18),
                          PremiumButton(
                            label: _selectedTab == ResultTab.preview ? 'Open Full Preview' : 'Open Code Viewer',
                            icon: _selectedTab == ResultTab.preview
                                ? CupertinoIcons.device_phone_portrait
                                : CupertinoIcons.chevron_left_slash_chevron_right,
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white,
                            foregroundColor: AppColors.textFor(context),
                            onPressed: () {
                              if (_selectedTab == ResultTab.preview) {
                                context.push('/preview', extra: component);
                              } else {
                                context.push(
                                  '/code',
                                  extra: CodeViewerArgs(
                                    component: component,
                                    initialLanguage: _selectedTab.language,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.paddingOf(context).bottom + 14,
                  child: ResultActions(
                    isSaved: component.isSaved,
                    onCopy: () => _showCopySheet(component),
                    onSave: () => _save(component),
                    onExport: () => _export(component),
                  ).animate().fadeIn(duration: 260.ms).moveY(begin: 20, end: 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(GeneratedComponent component) {
    switch (_selectedTab) {
      case ResultTab.preview:
        return GlassCard(
          key: const ValueKey('preview'),
          padding: const EdgeInsets.all(10),
          borderRadius: 30,
          child: PreviewWebView(fullHtml: component.fullHtml, height: 480),
        );
      case ResultTab.html:
      case ResultTab.css:
      case ResultTab.full:
        return CodeViewer(
          key: ValueKey(_selectedTab.name),
          language: _selectedTab.language,
          code: codeForLanguage(
            language: _selectedTab.language,
            html: component.html,
            css: component.css,
            fullHtml: component.fullHtml,
          ),
          height: 520,
        );
    }
  }
}

enum ResultTab { preview, html, css, full }

extension ResultTabX on ResultTab {
  String get label {
    switch (this) {
      case ResultTab.preview:
        return 'Preview';
      case ResultTab.html:
        return 'HTML';
      case ResultTab.css:
        return 'CSS';
      case ResultTab.full:
        return 'Full';
    }
  }

  String get language {
    switch (this) {
      case ResultTab.html:
        return 'HTML';
      case ResultTab.css:
        return 'CSS';
      case ResultTab.full:
      case ResultTab.preview:
        return 'Full';
    }
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onPreview,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PremiumIconButton(
          icon: CupertinoIcons.chevron_left,
          onPressed: onBack,
          semanticLabel: 'Back to generator',
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: CupertinoIcons.device_phone_portrait,
          onPressed: onPreview,
          semanticLabel: 'Open full preview',
        ),
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.selected, required this.onSelected});

  final ResultTab selected;
  final ValueChanged<ResultTab> onSelected;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(6),
      borderRadius: 22,
      child: Row(
        children: ResultTab.values.map((tab) {
          final isSelected = selected == tab;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 210),
                curve: Curves.easeOutCubic,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    tab.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected ? Colors.white : AppColors.mutedFor(context),
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
            Icon(CupertinoIcons.chevron_right, size: 16, color: AppColors.mutedFor(context)),
          ],
        ),
      ),
    );
  }
}
