import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Animated favorite button – tıklanınca dolup boşalır, mini scale animasyonu
class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onTap,
    this.size = 24,
    this.color,
  });

  final bool isFavorited;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    debugPrint('❤️ [FavoriteButton] tapped, isFavorited=${widget.isFavorited}');
    if (widget.onTap == null) return;
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) _controller.reverse();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.labelBlack;

    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            widget.isFavorited ? Icons.favorite : Icons.favorite_border,
            key: ValueKey<bool>(widget.isFavorited),
            size: widget.size,
            color: widget.isFavorited ? AppColors.redDot : color,
          ),
        ),
      ),
    );
  }
}
