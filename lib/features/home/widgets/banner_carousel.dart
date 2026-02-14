import 'dart:async';
import 'package:flutter/material.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/shared/models/banner_model.dart';
import 'package:skye_app/features/home/widgets/promo_card.dart';

/// Banner carousel widget with auto-scroll functionality
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    required this.isLoading,
  });

  final List<BannerModel> banners;
  final bool isLoading;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  PageController? _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      _initializeCarousel();
    }
  }

  @override
  void didUpdateWidget(BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.banners.isNotEmpty && _pageController == null) {
      _initializeCarousel();
    } else if (widget.banners.isEmpty && _pageController != null) {
      _disposeCarousel();
    }
  }

  @override
  void dispose() {
    _disposeCarousel();
    super.dispose();
  }

  void _initializeCarousel() {
    _pageController?.dispose();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.93,
    );
    _currentIndex = 0;
    _startTimer();
  }

  void _disposeCarousel() {
    _timer?.cancel();
    _pageController?.dispose();
    _pageController = null;
    _timer = null;
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.banners.isEmpty || _pageController == null) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _pageController == null || widget.banners.isEmpty) {
        timer.cancel();
        return;
      }

      final nextIndex = (_currentIndex + 1) % widget.banners.length;
      _pageController!.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _onPageChanged(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
      _startTimer();
    }
  }

  void _onBannerTap(BannerModel banner) {
    if (banner.type == 'video') {
      Navigator.of(context).pushNamed(
        AppRoutes.videoPlayer,
        arguments: {
          'videoUrl': banner.mediaUrl,
          'title': banner.title,
        },
      );
    } else if (banner.linkUrl != null) {
      // TODO: Implement navigation based on link_url
      debugPrint('🧭 [BannerCarousel] Banner tapped: ${banner.linkUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const SizedBox(
        height: 151,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.banners.length == 1) {
      return PromoCard(
        banner: widget.banners[0],
        onTap: () => _onBannerTap(widget.banners[0]),
      );
    }

    return SizedBox(
      height: 151,
      child: Listener(
        onPointerDown: (_) {
          _timer?.cancel();
          _timer = null;
        },
        onPointerUp: (_) => _startTimer(),
        onPointerCancel: (_) => _startTimer(),
        child: PageView.builder(
          controller: _pageController,
          physics: const PageScrollPhysics(),
          onPageChanged: _onPageChanged,
          itemCount: widget.banners.length,
          itemBuilder: (context, index) {
            final banner = widget.banners[index];
            return PromoCard(
              banner: banner,
              onTap: () => _onBannerTap(banner),
            );
          },
        ),
      ),
    );
  }
}

