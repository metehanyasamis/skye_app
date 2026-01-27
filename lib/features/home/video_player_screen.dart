import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:skye_app/shared/services/api_service.dart';

/// Video player screen for banner videos
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  static const routeName = '/video-player';

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize video after dependencies are available
    if (!_hasInitialized) {
      _hasInitialized = true;
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (!mounted) return;
    
    // Get arguments from route settings
    final route = ModalRoute.of(context);
    if (route == null) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Route not available';
        _isLoading = false;
      });
      return;
    }

    final args = route.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['videoUrl'] == null) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = 'Video URL not provided';
        _isLoading = false;
      });
      return;
    }

    final videoUrl = args['videoUrl'] as String;
    debugPrint('🎬 [VideoPlayerScreen] Initializing video: $videoUrl');

    try {
      // Get auth token for video request
      final authToken = ApiService.instance.getAuthToken();
      debugPrint('🔑 [VideoPlayerScreen] Auth token: ${authToken != null ? "YES" : "NO"}');
      if (authToken != null) {
        debugPrint('🔑 [VideoPlayerScreen] Token value: $authToken');
      }
      
      // Create video player controller with auth headers
      final headers = <String, String>{
        'Accept': 'video/*',
      };
      if (authToken != null) {
        headers['Authorization'] = authToken;
        debugPrint('🔑 [VideoPlayerScreen] Adding Authorization header: ${authToken.substring(0, authToken.length > 20 ? 20 : authToken.length)}...');
      } else {
        debugPrint('⚠️ [VideoPlayerScreen] No auth token available!');
      }
      
      debugPrint('📤 [VideoPlayerScreen] Request URL: $videoUrl');
      debugPrint('📤 [VideoPlayerScreen] Request headers: $headers');
      
      // Validate URL format
      try {
        final uri = Uri.parse(videoUrl);
        debugPrint('🔗 [VideoPlayerScreen] Parsed URI - Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}');
      } catch (e) {
        debugPrint('❌ [VideoPlayerScreen] Invalid URL format: $e');
        if (!mounted) return;
        setState(() {
          _hasError = true;
          _errorMessage = 'Invalid video URL format';
          _isLoading = false;
        });
        return;
      }
      
      // Test video URL accessibility with Dio first
      try {
        debugPrint('🔍 [VideoPlayerScreen] Testing video URL accessibility...');
        final dio = Dio();
        if (authToken != null) {
          dio.options.headers['Authorization'] = authToken;
        }
        dio.options.headers['Accept'] = 'video/*';
        
        final response = await dio.head(
          videoUrl,
          options: Options(
            followRedirects: true,
            validateStatus: (status) => status! < 500,
          ),
        ).timeout(const Duration(seconds: 10));
        
        debugPrint('📊 [VideoPlayerScreen] HEAD request status: ${response.statusCode}');
        if (response.statusCode != null && response.statusCode! >= 400) {
          throw DioException(
            requestOptions: RequestOptions(path: videoUrl),
            response: response,
            type: DioExceptionType.badResponse,
            message: 'Video URL returned status ${response.statusCode}',
          );
        }
        debugPrint('✅ [VideoPlayerScreen] Video URL is accessible');
      } catch (e) {
        debugPrint('⚠️ [VideoPlayerScreen] Video URL accessibility test failed: $e');
        if (e is DioException) {
          final statusCode = e.response?.statusCode;
          if (statusCode == 403) {
            if (!mounted) return;
            setState(() {
              _hasError = true;
              _errorMessage = 'Access denied. Please check your authentication.';
              _isLoading = false;
            });
            return;
          } else if (statusCode == 404) {
            if (!mounted) return;
            setState(() {
              _hasError = true;
              _errorMessage = 'Video not found. The video may have been removed.';
              _isLoading = false;
            });
            return;
          }
        }
        // Continue anyway - video player might still work
        debugPrint('⚠️ [VideoPlayerScreen] Continuing despite accessibility test failure');
      }
      
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: headers,
      );

      // Add listener for initialization
      _controller!.addListener(_videoListener);

      // Initialize video with timeout
      await _controller!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Video initialization timed out after 30 seconds');
        },
      );
      
      debugPrint('🎬 [VideoPlayerScreen] Video controller initialized, waiting for video to load...');
    } catch (e) {
      debugPrint('❌ [VideoPlayerScreen] Failed to initialize video: $e');
      if (!mounted) return;
      String errorMsg = 'Failed to load video';
      if (e is TimeoutException) {
        errorMsg = 'Video loading timed out. Please check your connection.';
      } else if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        errorMsg = 'Access denied. Please check your authentication.';
      } else if (e.toString().contains('404') || e.toString().contains('Not Found')) {
        errorMsg = 'Video not found. The video may have been removed.';
      } else if (e.toString().contains('Source error')) {
        errorMsg = 'Video source error. The video file may be corrupted or inaccessible.';
      } else {
        errorMsg = 'Failed to load video: ${e.toString()}';
      }
      setState(() {
        _hasError = true;
        _errorMessage = errorMsg;
        _isLoading = false;
      });
    }
  }

  void _videoListener() {
    if (!mounted) return;
    
    if (_controller == null) return;
    
    if (_controller!.value.hasError) {
      setState(() {
        _hasError = true;
        _errorMessage = _controller!.value.errorDescription ?? 'Video playback error';
        _isLoading = false;
      });
      debugPrint('❌ [VideoPlayerScreen] Video error: ${_controller!.value.errorDescription}');
      _controller!.removeListener(_videoListener);
    } else if (_controller!.value.isInitialized) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('✅ [VideoPlayerScreen] Video initialized successfully');
      debugPrint('   Duration: ${_controller!.value.duration}');
      debugPrint('   Size: ${_controller!.value.size}');
      // Auto-play video
      _controller!.play();
      _controller!.removeListener(_videoListener);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final title = args?['title'] as String? ?? 'Video';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _errorMessage ?? 'Unknown error',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  )
                : _controller != null && _controller!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : const SizedBox(),
      ),
    );
  }
}
