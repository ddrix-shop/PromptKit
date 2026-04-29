import 'dart:io';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/generated_component.dart';

class ExportService {
  Future<File> createHtmlFile(GeneratedComponent component) async {
    final directory = await getTemporaryDirectory();
    final fileName = '${_slugify(component.title)}-${component.id.substring(0, 8)}.html';
    final file = File('${directory.path}/$fileName');
    return file.writeAsString(component.fullHtml, flush: true);
  }

  Future<ShareResult> shareHtmlFile(
    GeneratedComponent component, {
    Rect? sharePositionOrigin,
  }) async {
    final file = await createHtmlFile(component);
    return SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(file.path, mimeType: 'text/html')],
        title: component.title,
        subject: component.title,
        text: 'One-file HTML export from CraftUI Mobile.',
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  String _slugify(String value) {
    final slug = value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return slug.isEmpty ? 'craftui-component' : slug;
  }
}
