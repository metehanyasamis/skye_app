import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:skye_app/shared/models/blog_model.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Blog webview screen - displays blog post in app using WebView
class BlogWebViewScreen extends StatefulWidget {
  const BlogWebViewScreen({super.key});

  static const routeName = '/blog/webview';

  @override
  State<BlogWebViewScreen> createState() => _BlogWebViewScreenState();
}

class _BlogWebViewScreenState extends State<BlogWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  String? _blogUrl;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    SystemUIHelper.setLightStatusBar();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_hasInitialized) return;
    _hasInitialized = true;

    // Get blog from route arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      debugPrint('❌ [BlogWebViewScreen] Missing or invalid arguments');
      Navigator.of(context).pop();
      return;
    }

    final blog = args['blog'] as BlogModel?;
    if (blog == null) {
      debugPrint('❌ [BlogWebViewScreen] Blog not provided');
      Navigator.of(context).pop();
      return;
    }

    // Build blog URL using slug
    // Assuming blog URL format: https://skye.dijicrea.net/blog/{slug}
    _blogUrl = 'https://skye.dijicrea.net/blog/${blog.slug}';
    debugPrint('🌐 [BlogWebViewScreen] Loading blog URL: $_blogUrl');

    // Start timeout timer immediately (before loadRequest)
    // This ensures timeout works even if onPageStarted is never called
    _timeoutTimer = Timer(const Duration(seconds: 7), () {
      if (mounted && _isLoading) {
        debugPrint('⏱️ [BlogWebViewScreen] Timeout - page took too long to load');
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Sayfa yüklenemedi. Web sitesi şu anda erişilebilir olmayabilir.';
        });
      }
    });

    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('🌐 [BlogWebViewScreen] Page started: $url');
            _timeoutTimer?.cancel();
            // Reset timeout when page actually starts loading
            _timeoutTimer = Timer(const Duration(seconds: 10), () {
              if (mounted && _isLoading) {
                debugPrint('⏱️ [BlogWebViewScreen] Timeout - page took too long to load');
                setState(() {
                  _isLoading = false;
                  _hasError = true;
                  _errorMessage = 'Sayfa yüklenemedi. Web sitesi şu anda erişilebilir olmayabilir.';
                });
              }
            });
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _errorMessage = null;
              });
            }
          },
          onPageFinished: (String url) {
            debugPrint('🌐 [BlogWebViewScreen] Page finished: $url');
            _timeoutTimer?.cancel();
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('❌ [BlogWebViewScreen] Web resource error: ${error.description}');
            debugPrint('   Error code: ${error.errorCode}');
            debugPrint('   Error type: ${error.errorType}');
            _timeoutTimer?.cancel();
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                if (error.errorCode == -1009 || error.errorCode == -1001) {
                  _errorMessage = 'İnternet bağlantısı yok veya sayfa bulunamadı.';
                } else if (error.errorCode == -1003) {
                  _errorMessage = 'Web sitesi bulunamadı. Site henüz yayında olmayabilir.';
                } else {
                  _errorMessage = 'Sayfa yüklenirken bir hata oluştu: ${error.description}';
                }
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_blogUrl!));
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _retryLoad() {
    if (_blogUrl != null && _controller != null) {
      debugPrint('🔄 [BlogWebViewScreen] Retrying load: $_blogUrl');
      
      // Cancel existing timeout
      _timeoutTimer?.cancel();
      
      // Reset state
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = null;
      });
      
      // Start new timeout timer
      _timeoutTimer = Timer(const Duration(seconds: 7), () {
        if (mounted && _isLoading) {
          debugPrint('⏱️ [BlogWebViewScreen] Retry timeout - page took too long to load');
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = 'Sayfa yüklenemedi. Web sitesi şu anda erişilebilir olmayabilir.';
          });
        }
      });
      
      // Reload the page
      _controller!.loadRequest(Uri.parse(_blogUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.navy900,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Blog',
          style: TextStyle(
            color: AppColors.navy900,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.textGrayLight,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage ?? 'Bir hata oluştu',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.navy900,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _retryLoad,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueBright,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Tekrar Dene',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    WebViewWidget(controller: _controller!),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
    );
  }
}
