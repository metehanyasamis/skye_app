import 'package:flutter/material.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/widgets/skye_logo.dart';

class TimeBuildingPostScreen extends StatefulWidget {
  const TimeBuildingPostScreen({super.key});

  static const routeName = '/time-building/post';

  @override
  State<TimeBuildingPostScreen> createState() => _TimeBuildingPostScreenState();
}

class _TimeBuildingPostScreenState extends State<TimeBuildingPostScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _arrivalDateController = TextEditingController();
  final _licensesController = TextEditingController();
  final _costController = TextEditingController();
  int _passengers = 1;

  @override
  void initState() {
    super.initState();
    debugPrint('🧱 [TimeBuildingPostScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🧱 [TimeBuildingPostScreen] dispose');

    _fromController.dispose();
    _toController.dispose();
    _departureDateController.dispose();
    _arrivalDateController.dispose();
    _licensesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _swapFromTo() {
    debugPrint('🔁 [TimeBuildingPostScreen] swap FROM/TO');
    final temp = _fromController.text;
    _fromController.text = _toController.text;
    _toController.text = temp;
    setState(() {});
  }

  void _onPost() {
    debugPrint('📮 [TimeBuildingPostScreen] POST tapped');
    debugPrint('   FROM: ${_fromController.text}');
    debugPrint('   TO: ${_toController.text}');
    debugPrint('   Departure: ${_departureDateController.text}');
    debugPrint('   Arrival: ${_arrivalDateController.text}');
    debugPrint('   Licenses: ${_licensesController.text}');
    debugPrint('   Cost: ${_costController.text}');
    debugPrint('   Passengers: $_passengers');

    // TODO: Submit post
  }

  void _decreasePassengers() {
    debugPrint('➖ [TimeBuildingPostScreen] decrease passengers');
    setState(() {
      if (_passengers > 1) {
        _passengers--;
      }
    });
    debugPrint('   Passengers now: $_passengers');
  }

  void _increasePassengers() {
    debugPrint('➕ [TimeBuildingPostScreen] increase passengers');
    setState(() {
      _passengers++;
    });
    debugPrint('   Passengers now: $_passengers');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧱 [TimeBuildingPostScreen] build');

    // Set status bar style for light background
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: Column(
        children: [
          // Top header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 16),
            child: Row(
              children: [
                const SkyeLogo(type: 'logo', color: 'blue', height: 72),
                const Spacer(),

                // Location
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF8F9BB3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '1 World Wy...',
                        style: TextStyle(
                          fontSize: 15,
                          color:
                          const Color(0xFF8F9BB3).withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Notification icon
                Stack(
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      size: 24,
                      color: AppColors.labelBlack,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 32 / 24,
                      ),
                      children: [
                        TextSpan(
                          text: 'Split the payment ',
                          style: TextStyle(color: Color(0xFF007BA7)),
                        ),
                        TextSpan(
                          text: 'with other safety pilots',
                          style: TextStyle(color: Color(0xFF344054)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Form fields
                  Column(
                    children: [
                      // From where / Where to (combined card)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF101828)
                                  .withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 5),
                              spreadRadius: -4,
                            ),
                            BoxShadow(
                              color: const Color(0xFF101828)
                                  .withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 15),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _SearchInput(
                              icon: Icons.location_on,
                              hint: 'From where?',
                              controller: _fromController,
                              onChanged: (v) => debugPrint(
                                '⌨️ [TimeBuildingPostScreen] FROM changed: $v',
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: AppColors.borderLight,
                            ),
                            _SearchInput(
                              icon: Icons.location_on,
                              hint: 'Where to?',
                              controller: _toController,
                              onChanged: (v) => debugPrint(
                                '⌨️ [TimeBuildingPostScreen] TO changed: $v',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.swap_vert,
                                  size: 20,
                                  color: AppColors.labelBlack,
                                ),
                                onPressed: _swapFromTo,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date of departure
                      _SearchInput(
                        icon: Icons.calendar_today,
                        hint: 'Date of departure',
                        controller: _departureDateController,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Departure changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Date of arrival
                      _SearchInput(
                        icon: Icons.calendar_today,
                        hint: 'Date of arrival',
                        controller: _arrivalDateController,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Arrival changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Licenses
                      _SearchInput(
                        icon: Icons.card_membership,
                        hint: 'Licenses',
                        controller: _licensesController,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Licenses changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cost
                      _SearchInput(
                        icon: Icons.attach_money,
                        hint: 'Cost',
                        controller: _costController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => debugPrint(
                          '⌨️ [TimeBuildingPostScreen] Cost changed: $v',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Passengers with counter
                      Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF101828)
                                  .withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 5),
                              spreadRadius: -4,
                            ),
                            BoxShadow(
                              color: const Color(0xFF101828)
                                  .withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 15),
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.sentiment_satisfied_alt,
                              size: 24,
                              color: Color(0xFF1D2939),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Passengers',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF1D2939),
                              ),
                            ),
                            const Spacer(),

                            // Counter
                            Row(
                              children: [
                                _CounterButton(
                                  icon: Icons.remove,
                                  onPressed: _decreasePassengers,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '$_passengers',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1D2939),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _CounterButton(
                                  icon: Icons.add,
                                  onPressed: _increasePassengers,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Post button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy800,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
          Container(
            height: 77,
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.navy900,
              unselectedItemColor: AppColors.textSecondary,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              onTap: (index) {
                debugPrint('🧭 [TimeBuildingPostScreen] bottom nav tapped: $index');
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_bubble_outline),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.flight),
                  label: 'Flights',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: 'Logbook',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  const _SearchInput({
    required this.icon,
    required this.hint,
    required this.controller,
    this.trailing,
    this.keyboardType,
    this.onChanged,
  });

  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF1D2939),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1D2939),
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF98A2B3),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: const Color(0xFF1D2939),
        ),
      ),
    );
  }
}
