import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// HTML metni WebView ile gösterir (Terms, Privacy, Data Protection).
class HtmlContentScreen extends StatelessWidget {
  const HtmlContentScreen({super.key});

  static const routeName = '/profile/html-content';

  @override
  Widget build(BuildContext context) {
    debugPrint('📄 [HtmlContentScreen] build()');
    SystemUIHelper.setLightStatusBar();

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = args?['title'] as String? ?? 'Content';
    final html = args?['html'] as String? ?? '';

    const darkCss = '''
      body { color: #12121D !important; font-size: 16px; line-height: 1.5; }
      p, span, div, li, td, th { color: #12121D !important; }
      a { color: #2B4E71 !important; }
    ''';
    final wrappedHtml = html.isEmpty
        ? '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"><style>$darkCss</style></head><body><p>Content not available yet.</p></body></html>'
        : '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"><style>$darkCss</style></head><body>$html</body></html>';
    late final WebViewController controller;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.dataFromString(
          wrappedHtml,
          mimeType: 'text/html',
          encoding: utf8,
        ),
      );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [HtmlContentScreen] Back pressed');
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
