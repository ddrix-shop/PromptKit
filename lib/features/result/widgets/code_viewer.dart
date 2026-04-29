import 'package:flutter/material.dart';

import '../../../core/widgets/code_block_viewer.dart';

class CodeViewer extends StatelessWidget {
  const CodeViewer({
    super.key,
    required this.code,
    required this.language,
    this.height = 520,
  });

  final String code;
  final String language;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CodeBlockViewer(code: code, language: language),
    );
  }
}
