import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';

/// Reusable hourly rate selector widget
/// Allows selection of hourly rate (0-1000 range)
/// Circle stays fixed in center, numbers scroll through it
/// Center number is larger and animated
class HourlyRateSelector extends StatefulWidget {
  const HourlyRateSelector({
    super.key,
    required this.selectedRate,
    required this.onRateSelected,
  });

  final int selectedRate;
  final ValueChanged<int> onRateSelected;

  @override
  State<HourlyRateSelector> createState() => _HourlyRateSelectorState();
}

class _HourlyRateSelectorState extends State<HourlyRateSelector>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentRate = 20;
  static const int minRate = 0;
  static const int maxRate = 1000;
  static const double itemWidth = 44.0;
  static const double itemMargin = 12.0;
  static const double totalItemWidth = itemWidth + itemMargin;

  @override
  void initState() {
    super.initState();
    _currentRate = widget.selectedRate;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    
    // Scroll to initial position after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToRate(_currentRate, animate: false);
    });
  }

  @override
  void didUpdateWidget(HourlyRateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRate != widget.selectedRate) {
      _currentRate = widget.selectedRate;
      _scrollToRate(_currentRate);
      _animationController.forward(from: 0.0);
    }
  }

  void _scrollToRate(int rate, {bool animate = true}) {
    if (!_scrollController.hasClients) return;
    
    // Calculate offset accounting for padding
    final targetOffset = rate * totalItemWidth;
    
    if (animate) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(targetOffset);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final scrollOffset = _scrollController.offset;
    final centerIndex = (scrollOffset / totalItemWidth).round();
    final newRate = centerIndex.clamp(minRate, maxRate);
    
    if (newRate != _currentRate) {
      setState(() {
        _currentRate = newRate;
      });
      _animationController.forward(from: 0.0);
      widget.onRateSelected(newRate);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  double _getFontSize(int rate, bool isCenter) {
    if (isCenter) {
      return 18; // Larger for center
    }
    // Smaller for non-center items
    final distance = (rate - _currentRate).abs();
    if (distance == 0) return 18;
    if (distance == 1) return 14;
    if (distance == 2) return 12;
    return 10;
  }

  double _getOpacity(int rate, bool isCenter) {
    if (isCenter) return 1.0;
    final distance = (rate - _currentRate).abs();
    if (distance == 0) return 1.0;
    if (distance == 1) return 0.7;
    if (distance == 2) return 0.5;
    return 0.3;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the actual available width instead of screen width
        final availableWidth = constraints.maxWidth;
        final centerPosition = availableWidth / 2 - itemWidth / 2;
        // Add padding to allow first and last items to be centered
        final padding = centerPosition;

        return SizedBox(
          height: 44,
          child: Stack(
            children: [
              // Fixed circle in center
              Positioned(
                left: centerPosition,
                top: 0,
                child: Container(
                  width: itemWidth,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(color: AppColors.labelBlack, width: 1),
                  ),
                ),
              ),
              // Scrollable numbers
              ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: maxRate - minRate + 1, // 0 to 1000
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: padding),
            itemBuilder: (context, index) {
              final rate = minRate + index;
              final isCenter = rate == _currentRate;

              return GestureDetector(
                onTap: () {
                  DebugLogger.log('HourlyRateSelector', 'rate tapped', {'rate': rate});
                  _currentRate = rate;
                  _scrollToRate(rate);
                  widget.onRateSelected(rate);
                },
                child: Container(
                  width: itemWidth,
                  height: 44,
                  margin: const EdgeInsets.only(right: itemMargin),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isCenter ? _scaleAnimation.value : 1.0,
                          child: Opacity(
                            opacity: _getOpacity(rate, isCenter),
                            child: Text(
                              rate.toString(),
                              style: TextStyle(
                                fontSize: _getFontSize(rate, isCenter),
                                fontWeight: isCenter ? FontWeight.w600 : FontWeight.normal,
                                color: AppColors.labelBlack,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
      },
    );
  }
}
