import 'package:flutter/material.dart';

import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/auth_service.dart';
import 'package:skye_app/shared/services/user_type_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/confirm_dialog.dart';

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

    final bottomNavHeight = 60 + MediaQuery.of(context).viewPadding.bottom;

    return TabShell(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: bottomNavHeight + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16 + MediaQuery.of(context).padding.top),

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pelin Doğrul',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Certified CFI',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

            // Test – User type (Standard / CFI / Safety)
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'User type (test)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelBlack,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<UserType>(
              valueListenable: UserTypeService.instance.userTypeNotifier,
              builder: (context, userType, _) {
                return _MenuSection(
                  children: [
                    _UserTypeItem(
                      label: 'Standard user',
                      isSelected: userType == UserType.standard,
                      onTap: () {
                        DebugLogger.log('ProfileScreen', 'test user type', {'type': 'standard'});
                        UserTypeService.instance.setUserType(UserType.standard);
                      },
                    ),
                    _UserTypeItem(
                      label: 'CFI pilot',
                      isSelected: userType == UserType.cfi,
                      onTap: () {
                        DebugLogger.log('ProfileScreen', 'test user type', {'type': 'cfi'});
                        UserTypeService.instance.setUserType(UserType.cfi);
                      },
                    ),
                    _UserTypeItem(
                      label: 'Safety pilot',
                      isSelected: userType == UserType.safetyPilot,
                      onTap: () {
                        DebugLogger.log('ProfileScreen', 'test user type', {'type': 'safetyPilot'});
                        UserTypeService.instance.setUserType(UserType.safetyPilot);
                      },
                    ),
                  ],
                );
              },
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
                  onTap: () async {
                    DebugLogger.log('ProfileScreen', 'logout pressed');
                    final nav = Navigator.of(context, rootNavigator: true);
                    await ConfirmDialog.show(
                      context,
                      title: 'Çıkış yap',
                      message: 'Çıkış yapmak istediğinize emin misiniz?',
                      cancelLabel: 'İptal',
                      confirmLabel: 'Çıkış yap',
                      onConfirm: () async {
                        await AuthService.instance.logout();
                        if (!context.mounted) return;
                        nav.pushNamedAndRemoveUntil(
                          AppRoutes.welcome,
                          (route) => false,
                        );
                      },
                    );
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
                  onTap: () async {
                    DebugLogger.log('ProfileScreen', 'delete account pressed');
                    final nav = Navigator.of(context, rootNavigator: true);
                    await ConfirmDialog.show(
                      context,
                      title: 'Hesabı sil',
                      message:
                          'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
                      cancelLabel: 'İptal',
                      confirmLabel: 'Hesabı sil',
                      confirmIsDestructive: true,
                      onConfirm: () async {
                        await AuthService.instance.deleteAccount();
                        if (!context.mounted) return;
                        nav.pushNamedAndRemoveUntil(
                          AppRoutes.welcome,
                          (route) => false,
                        );
                      },
                    );
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

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _UserTypeItem extends StatelessWidget {
  const _UserTypeItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 22,
                color: AppColors.navy800,
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.labelBlack.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? AppColors.primaryBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grayDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
