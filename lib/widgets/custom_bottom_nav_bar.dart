/*import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _bubbleAnimation;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home, label: 'Home', route: '/home'),
    _NavItem(icon: Icons.school, label: 'CFI', route: '/cfi/listing'),
    _NavItem(icon: Icons.flight, label: 'Aircraft', route: '/aircraft/listing'),
    _NavItem(
      icon: Icons.access_time,
      label: 'Time Building',
      route: '/time-building/listing',
    ),
    _NavItem(icon: Icons.person_outline, label: 'Profile', route: '/profile'),
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bubbleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCurrentIndex();
      _animationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateCurrentIndex() {
    final route = ModalRoute.of(context)?.settings.name;
    if (route == null) return;

    final index = _navItems.indexWhere((item) => item.route == route);
    if (index == -1) return;

    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      _animationController.reset();
      _animationController.forward();
    } else {
      if (!_animationController.isAnimating) {
        _animationController.value = 1.0;
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);
    _animationController.forward(from: 0.0);

    Navigator.of(context).pushReplacementNamed(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
                  (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = index == _currentIndex;
    final item = _navItems[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _bubbleAnimation,
          builder: (context, _) {
            final bubbleScale = isSelected ? _bubbleAnimation.value : 0.0;
            final iconOffset =
            isSelected ? -16.0 * _bubbleAnimation.value : 0.0;
            final iconScale = isSelected
                ? 1.0 + (0.2 * _bubbleAnimation.value)
                : 1.0;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (isSelected && bubbleScale > 0)
                  Positioned(
                    top: -24,
                    child: Transform.scale(
                      scale: bubbleScale,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, iconOffset),
                  child: Transform.scale(
                    scale: iconScale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 26,
                          color: isSelected
                              ? AppColors.navy900
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 4),
                        AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

 */


import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  Animation<double>? _bubble;

  final List<_NavItem> _items = [
    _NavItem(label: 'Home', route: '/home', icon: 'assets/icons/nav_home.png'),
    _NavItem(label: 'CFI', route: '/cfi/listing', icon: 'assets/icons/nav_cfi.png'),
    _NavItem(label: 'Aircraft', route: '/aircraft/listing', icon: 'assets/icons/nav_aircraft.png'),
    _NavItem(label: 'Time', route: '/time-building/listing', icon: 'assets/icons/nav_time.png'),
    _NavItem(label: 'Profile', route: '/profile', icon: 'assets/icons/nav_profile.png'),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _bubble = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncIndexWithRoute();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncIndexWithRoute();
  }


  void _syncIndexWithRoute() {
    final route = ModalRoute.of(context)?.settings.name;
    if (route == null) return;

    final index = _items.indexWhere((e) => e.route == route);
    if (index == -1) return;

    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _controller.forward(from: 0);
    }
  }

  void _onTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);
    _controller.forward(from: 0);

    Navigator.of(context).pushReplacementNamed(_items[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        height: 78,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) => _buildItem(i)),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final isSelected = index == _currentIndex;
    final item = _items[index];

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(index),
        child: AnimatedBuilder(
          animation: _bubble ?? _controller, // ✅ null-safe
          builder: (_, __) {
            final t = isSelected ? (_bubble?.value ?? 0.0) : 0.0;

            final y = -10.0 * t;
            final scale = 1.0 + (0.10 * t);

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (isSelected)
                  Positioned(
                    top: -18,
                    child: Transform.scale(
                      scale: t,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: 0.16),
                        ),
                      ),
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, y),
                  child: Transform.scale(
                    scale: scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          item.icon,
                          width: 26,
                          height: 26,
                          color: isSelected ? AppColors.navy900 : AppColors.textSecondary,
                        ),
                        const SizedBox(height: 6),
                        AnimatedOpacity(
                          opacity: isSelected ? 1 : 0,
                          duration: const Duration(milliseconds: 160),
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String route;
  final String icon;

  _NavItem({
    required this.label,
    required this.route,
    required this.icon,
  });
}
