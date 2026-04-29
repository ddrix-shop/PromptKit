import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/constants/app_colors.dart';

class PreviewWebView extends StatefulWidget {
  const PreviewWebView({
    super.key,
    required this.fullHtml,
    this.height = 430,
  });

  final String fullHtml;
  final double height;

  @override
  State<PreviewWebView> createState() => _PreviewWebViewState();
}

class _PreviewWebViewState extends State<PreviewWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) => NavigationDecision.prevent,
        ),
      )
      ..loadHtmlString(widget.fullHtml);
  }

  @override
  void didUpdateWidget(covariant PreviewWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fullHtml != widget.fullHtml) {
      _controller.loadHtmlString(widget.fullHtml);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              Positioned.fill(
                child: ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                    child: CupertinoActivityIndicator(color: AppColors.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
