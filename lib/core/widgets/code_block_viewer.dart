import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CodeBlockViewer extends StatelessWidget {
  const CodeBlockViewer({
    super.key,
    required this.code,
    required this.language,
  });

  final String code;
  final String language;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineCount = code.split('\n').length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? const Color(0xFF0B0B0B) : const Color(0xFFF5F2ED),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                _Dot(color: Colors.redAccent.withOpacity(0.8)),
                const SizedBox(width: 6),
                _Dot(color: Colors.amber.withOpacity(0.8)),
                const SizedBox(width: 6),
                _Dot(color: Colors.greenAccent.withOpacity(0.8)),
                const Spacer(),
                Text(
                  '$language • $lineCount lines',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width - 72,
                    ),
                    child: SelectableText.rich(
                      _highlight(context, code, language),
                      style: TextStyle(
                        fontFamily: 'Menlo',
                        fontFamilyFallback: const ['SF Mono', 'Courier New', 'monospace'],
                        fontSize: 12.5,
                        height: 1.58,
                        color: isDark ? AppColors.text : AppColors.darkText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _highlight(BuildContext context, String source, String language) {
    final isCss = language.toLowerCase().contains('css');
    final patterns = isCss
        ? RegExp(r'#[0-9a-fA-F]{3,8}|[.#][a-zA-Z0-9_-]+|\b[a-zA-Z-]+(?=\s*:)|"[^"]*"|\b\d+(?:\.\d+)?(?:px|rem|em|%|vw|vh)?\b|[{}:;(),]')
        : RegExp(r'<!--[\s\S]*?-->|</?[a-zA-Z][a-zA-Z0-9-]*|\s[a-zA-Z_:][-a-zA-Z0-9_:.]*(?==)|"[^"]*"|[<>/=]');

    final spans = <TextSpan>[];
    var cursor = 0;

    for (final match in patterns.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }
      final token = match.group(0)!;
      spans.add(TextSpan(text: token, style: TextStyle(color: _colorForToken(token, isCss))));
      cursor = match.end;
    }

    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }

    return TextSpan(children: spans);
  }

  Color _colorForToken(String token, bool isCss) {
    if (token.startsWith('<!--')) return const Color(0xFF7C7C7C);
    if (token.startsWith('"')) return const Color(0xFF55D187);
    if (token.startsWith('#') && token.length > 2 && RegExp(r'^#[0-9a-fA-F]').hasMatch(token)) {
      return const Color(0xFFFFC46B);
    }
    if (token.startsWith('.') || token.startsWith('#')) return const Color(0xFF86E7FF);
    if (RegExp(r'^\d').hasMatch(token)) return const Color(0xFFFFC46B);
    if (isCss && RegExp(r'^[a-zA-Z-]+$').hasMatch(token)) return AppColors.primarySoft;
    if (token.startsWith('<') || token == '>' || token == '/>' || token == '</') {
      return AppColors.primary;
    }
    if (token.trim().isNotEmpty && !isCss) return const Color(0xFF86E7FF);
    return const Color(0xFFA3A3A3);
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
