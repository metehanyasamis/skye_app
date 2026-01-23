import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/utils/system_ui_helper.dart';
import 'package:skye_app/widgets/custom_bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _cfiProfileEnabled = false;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('ProfileScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.labelBlack,
              ),
            ),

            const SizedBox(height: 16),

            // Profile card
            Container(
              height: 89,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.navy800,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 44,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Profile picture
                  Container(
                    width: 57,
                    height: 57,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.cardLight,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Name and subtitle
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pelin Doğrul',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Certified CFI',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit icon
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      debugPrint('✏️ [ProfileScreen] edit pressed');
                      // TODO: Edit profile
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Menu items
            _MenuSection(
              children: [
                _MenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Purchases',
                  subtitle: 'Make changes to your account',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: AppColors.textGray,
                        size: 20,
                      ),
                    ],
                  ),
                  onTap: () {
                    debugPrint('🛍️ [ProfileScreen] purchases pressed');
                    // TODO: Navigate to purchases
                  },
                ),
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Safety Pilot Profile',
                  subtitle: 'Manage your saved account',
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onTap: () {
                    debugPrint('🧑‍✈️ [ProfileScreen] safety pilot pressed');
                    // TODO: Navigate to safety pilot profile
                  },
                ),
                _MenuItem(
                  icon: Icons.flight,
                  title: 'CFI Profile',
                  subtitle: 'Manage your informations',
                  trailing: Switch(
                    value: _cfiProfileEnabled,
                    onChanged: (value) {
                      debugPrint('🧑‍🏫 [ProfileScreen] cfi switch -> $value');
                      setState(() {
                        _cfiProfileEnabled = value;
                      });
                    },
                    activeThumbColor: AppColors.navy800,
                  ),
                  onTap: null, // Handled by switch
                ),
                _MenuItem(
                  icon: Icons.logout,
                  title: 'Log out',
                  subtitle: 'Further secure your account for safety',
                  titleColor: AppColors.grayPrimary,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onTap: () {
                    debugPrint('🚪 [ProfileScreen] logout pressed');
                    // TODO: Log out
                  },
                ),
                _MenuItem(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Further secure your account for safety',
                  titleColor: AppColors.grayPrimary,
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onTap: () {
                    debugPrint('🗑️ [ProfileScreen] delete pressed');
                    // TODO: Delete account
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // More section
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'More',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelBlack,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _MenuSection(
              children: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onTap: () {
                    debugPrint('🆘 [ProfileScreen] help pressed');
                    // TODO: Navigate to help & support
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'About App',
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textGray,
                    size: 20,
                  ),
                  onTap: () {
                    debugPrint('ℹ️ [ProfileScreen] about pressed');
                    // TODO: Navigate to about app
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 44,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.cardLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.labelBlack,
              ),
            ),

            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.primaryBlack,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: AppColors.grayDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
