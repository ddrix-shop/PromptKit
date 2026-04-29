import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/code_helpers.dart';
import '../../core/utils/snackbars.dart';
import '../../core/widgets/code_block_viewer.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/premium_icon_button.dart';
import '../../data/models/generated_component.dart';
import '../../providers/app_providers.dart';

class CodeViewerArgs {
  const CodeViewerArgs({required this.component, this.initialLanguage = 'HTML'});

  final GeneratedComponent component;
  final String initialLanguage;
}

class CodeViewerScreen extends ConsumerStatefulWidget {
  const CodeViewerScreen({super.key, this.args});

  final CodeViewerArgs? args;

  @override
  ConsumerState<CodeViewerScreen> createState() => _CodeViewerScreenState();
}

class _CodeViewerScreenState extends ConsumerState<CodeViewerScreen> {
  late String _language;

  @override
  void initState() {
    super.initState();
    _language = widget.args?.initialLanguage == 'Full' ? 'Full' : widget.args?.initialLanguage ?? 'HTML';
  }

  @override
  Widget build(BuildContext context) {
    final component = widget.args?.component ?? ref.watch(currentGeneratedComponentProvider);

    if (component == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: EmptyState(
                title: 'No code available',
                message: 'Generate a component first to inspect code.',
                actionLabel: 'Open generator',
                onAction: () => context.go('/home'),
              ),
            ),
          ),
        ),
      );
    }

    final code = codeForLanguage(
      language: _language,
      html: component.html,
      css: component.css,
      fullHtml: component.fullHtml,
    );

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
                        Text('Code Viewer', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 3),
                        Text(component.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  PremiumIconButton(
                    icon: CupertinoIcons.doc_on_doc,
                    onPressed: () async {
                      await FlutterClipboard.copy(code);
                      if (context.mounted) showCraftSnack(context, '$_language copied to clipboard.');
                    },
                    semanticLabel: 'Copy selected code',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _LanguageTabs(
                selected: _language,
                onSelected: (language) => setState(() => _language = language),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: CodeBlockViewer(code: code, language: _language),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTabs extends StatelessWidget {
  const _LanguageTabs({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const languages = ['HTML', 'CSS', 'Full'];
    return GlassCard(
      padding: const EdgeInsets.all(6),
      borderRadius: 22,
      child: Row(
        children: languages.map((language) {
          final isSelected = selected == language;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onSelected(language),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 210),
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    language,
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
