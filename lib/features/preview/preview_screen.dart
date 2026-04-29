import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/snackbars.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../data/models/generated_component.dart';
import '../../providers/app_providers.dart';
import '../result/widgets/preview_webview.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key, this.component});

  final GeneratedComponent? component;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = component ?? ref.watch(currentGeneratedComponentProvider);

    if (resolved == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: EmptyState(
                title: 'No preview available',
                message: 'Generate a component first to open the full preview.',
                actionLabel: 'Open generator',
                onAction: () => context.go('/home'),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
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
                        Text(resolved.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 3),
                        Text('Live mobile preview', style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  PremiumIconButton(
                    icon: CupertinoIcons.doc_on_doc,
                    onPressed: () async {
                      await FlutterClipboard.copy(resolved.fullHtml);
                      if (context.mounted) showCraftSnack(context, 'Full code copied to clipboard.');
                    },
                    semanticLabel: 'Copy full code',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(8),
                  borderRadius: 30,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return PreviewWebView(
                        fullHtml: resolved.fullHtml,
                        height: constraints.maxHeight,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Rendered with webview_flutter using the generated one-file HTML document.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.mutedFor(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
