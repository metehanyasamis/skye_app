import 'package:flutter/material.dart';
import 'package:skye_app/shared/theme/app_colors.dart';

/// Tab / shell tarafından dışarıdan verilecek nav öğesi.
class NavItemConfig {
  const NavItemConfig({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final String icon;
}

/// Alt navigasyon çubuğu. Nav öğeleri [items] ile dışarıdan yönetilir.
class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    super.key,
    required this.items,
  });

  final List<NavItemConfig> items;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _controller;

  List<NavItemConfig> get _items => widget.items;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncIndex();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncIndex() {
    final route = ModalRoute.of(context)?.settings.name;
    final index = _items.indexWhere((e) => e.route == route);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
      _controller.forward(from: 0);
    }
  }

  void _onTap(int i) {
    if (i == _currentIndex) return;
    setState(() => _currentIndex = i);
    _controller.forward(from: 0);
    Navigator.of(context).pushReplacementNamed(_items[i].route);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return SizedBox(
      height: 60 + bottomInset,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 60),
            painter: _NavBarPainter(
              index: _currentIndex,
              itemCount: _items.length,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _items.length,
                  (i) => _NavButton(
                    item: _items[i],
                    selected: i == _currentIndex,
                    controller: _controller,
                    onTap: () => _onTap(i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.controller,
    required this.onTap,
  });

  final NavItemConfig item;
  final bool selected;
  final AnimationController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = selected ? controller.value : 0.0;
          return SizedBox(
            width: 64,
            child: Transform.translate(
              offset: Offset(0, -6 * t),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    item.icon,
                    width: 30,
                    height: 30,
                    color: selected
                        ? AppColors.navy900
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: selected ? 1 : 0,
                    duration: const Duration(milliseconds: 120),
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        color: AppColors.navy900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavBarPainter extends CustomPainter {
  final int index;
  final int itemCount;

  _NavBarPainter({
    required this.index,
    required this.itemCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.white;
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

    final itemWidth = size.width / itemCount;
    final centerX = itemWidth * index + itemWidth / 2;
    const barLift = 30.0;

    final path = Path();
    path.moveTo(0, -barLift);
    path.lineTo(centerX - 38, -barLift);
    path.quadraticBezierTo(centerX, -65, centerX + 38, -barLift);
    path.lineTo(size.width, -barLift);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavBarPainter oldDelegate) {
    return oldDelegate.index != index;
  }
}
