import 'dart:io';

import 'package:flutter/material.dart';

import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/app/shell/tab_shell.dart';
import 'package:skye_app/shared/models/user_type.dart';
import 'package:skye_app/shared/services/api_service.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/services/profile_avatar_cache.dart';
import 'package:skye_app/shared/services/settings_api_service.dart';
import 'package:skye_app/shared/services/user_type_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/confirm_dialog.dart';
import 'package:skye_app/shared/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  Map<String, dynamic> _settings = {};
  int? _myPilotId;
  bool _loading = true;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    debugPrint('👤 [ProfileScreen] initState()');
    _load();
  }

  Future<void> _load() async {
    debugPrint('👤 [ProfileScreen] _load() start');
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        AuthApiService.instance.getMe(),
        SettingsApiService.instance.getSettings(),
        _resolveMyPilotId(),
      ]);
      if (mounted) {
        final raw = results[0] as Map<String, dynamic>?;
        final inner = raw?['user'] as Map<String, dynamic>? ?? raw;
        setState(() {
          _user = inner;
          _settings = results[1] as Map<String, dynamic>? ?? {};
          _myPilotId = results[2] as int?;
          _loading = false;
        });
        debugPrint('👤 [ProfileScreen] _load() success user=${_user != null} settings=${_settings.isNotEmpty} pilotId=$_myPilotId');
      }
    } catch (e, st) {
      debugPrint('❌ [ProfileScreen] _load() error: $e\n$st');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<int?> _resolveMyPilotId() async {
    try {
      final user = await AuthApiService.instance.getMe();
      final pid = user['pilot_id'] ?? user['cfi_profile_id'] ?? user['safety_pilot_id'];
      if (pid != null) {
        final id = pid is int ? pid : int.tryParse(pid.toString());
        if (id != null) return id;
      }
      final apps = await PilotApiService.instance.getPilotApplications();
      for (final a in apps) {
        if (a['status']?.toString().toLowerCase() == 'approved') {
          final pid = a['pilot_id'] ?? a['id'];
          if (pid != null) {
            final id = pid is int ? pid : int.tryParse(pid.toString());
            if (id != null) return id;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  String get _userName {
    if (_user == null) return '';
    final fn = _user!['first_name'] ?? _user!['firstName'] ?? '';
    final ln = _user!['last_name'] ?? _user!['lastName'] ?? '';
    final combined = '${fn.toString().trim()} ${ln.toString().trim()}'.trim();
    if (combined.isNotEmpty) return combined;
    final n = _user!['name'] ?? _user!['full_name'];
    if (n != null && n.toString().trim().isNotEmpty) return n.toString().trim();
    return '';
  }

  String? get _avatarUrl {
    final p = _user?['profile_photo_path'] ?? _user?['avatar'] ?? _user?['profile_image'] ?? _user?['photo_url'];
    if (p == null || p.toString().isEmpty) return null;
    final path = p.toString().trim();
    if (path.startsWith('http')) return path;
    final base = ApiService.baseUrl.replaceFirst('/api', '');
    return base.endsWith('/') ? '$base$path' : '$base/$path';
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('ProfileScreen', 'build()');
    SystemUIHelper.setLightStatusBar();

    return TabShell(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                          SizedBox(height: 16 + MediaQuery.of(context).padding.top),

                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.labelBlack,
                            ),
                          ),

                          const SizedBox(height: 16),

                          _buildProfileCard(),

                          const SizedBox(height: 16),

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

                          _buildMenuSection(),

                          const SizedBox(height: 20),

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

                          _buildMoreSection(),

                          const SizedBox(height: 24),
                          _buildFooterWidget(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
    );
  }

  Widget _buildProfileCard() {
    final certifiedLabel = _certifiedLabel();
    return ValueListenableBuilder<UserType>(
      valueListenable: UserTypeService.instance.userTypeNotifier,
      builder: (context, userType, _) {
        return Container(
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
              Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: () {
                    final f = _avatarFile ?? ProfileAvatarCache.instance.file;
                    if (f != null && f.existsSync())
                      return ClipOval(
                        child: Image.file(
                          f,
                          fit: BoxFit.cover,
                          width: 57,
                          height: 57,
                        ),
                      );
                    return null;
                  }() ??
                      (_avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                _avatarUrl!,
                                fit: BoxFit.cover,
                                width: 57,
                                height: 57,
                                errorBuilder: (_, __, ___) => const CircleAvatar(
                                  backgroundColor: AppColors.cardLight,
                                  child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                                ),
                              ),
                            )
                          : null) ??
                      const CircleAvatar(
                              backgroundColor: AppColors.cardLight,
                              child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                            ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _userName.isEmpty ? 'Add your name' : _userName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (certifiedLabel != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        certifiedLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.white, size: 24),
                onPressed: () {
                  debugPrint('✏️ [ProfileScreen] edit pressed');
                  _navigateToProfileEdit(userType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String? _certifiedLabel() {
    final userType = UserTypeService.instance.userType;
    if (userType == UserType.cfi) return 'Certified CFI';
    if (userType == UserType.safetyPilot) return 'Certified Safety Pilot';
    return null;
  }

  void _navigateToProfileEdit(UserType userType) async {
    debugPrint('✏️ [ProfileScreen] edit -> EditProfileScreen (personal info)');
    final result = await Navigator.of(context).pushNamed(AppRoutes.editProfile);
    if (mounted && result != null && result is Map) {
      final updated = result['updated'] == true;
      final avatarFile = result['avatarFile'] as File?;
      if (updated) {
        if (avatarFile != null) ProfileAvatarCache.instance.set(avatarFile);
        setState(() => _avatarFile = avatarFile);
        _load();
      }
    }
  }

  void _navigateToPilotProfile(UserType userType) {
    if (userType == UserType.cfi) {
      if (_myPilotId != null) {
        debugPrint('🧑‍✈️ [ProfileScreen] navigate to CFI detail pilotId=$_myPilotId');
        Navigator.of(context).pushNamed(
          AppRoutes.cfiDetail,
          arguments: {'pilotId': _myPilotId},
        );
      } else {
        debugPrint('⚠️ [ProfileScreen] No pilot ID for CFI, cannot edit');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil bilgisi yüklenemedi. Lütfen tekrar deneyin.')),
        );
      }
    } else if (userType == UserType.safetyPilot) {
      if (_myPilotId != null) {
        debugPrint('🧑‍✈️ [ProfileScreen] navigate to Safety Pilot detail pilotId=$_myPilotId');
        Navigator.of(context).pushNamed(
          AppRoutes.safetyPilotDetail,
          arguments: {'pilotId': _myPilotId},
        );
      } else {
        debugPrint('⚠️ [ProfileScreen] No pilot ID for Safety Pilot, cannot edit');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil bilgisi yüklenemedi. Lütfen tekrar deneyin.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Düzenlemek için CFI veya Safety Pilot profiliniz olmalıdır.')),
      );
    }
  }

  Widget _buildMenuSection() {
    return ValueListenableBuilder<UserType>(
      valueListenable: UserTypeService.instance.userTypeNotifier,
      builder: (context, userType, _) {
        final children = <Widget>[
          _MenuItem(
            icon: Icons.favorite_border,
            title: 'Favorites',
            subtitle: 'Favorite CFI, Aircraft and Safety Pilot',
            trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
            onTap: () {
              debugPrint('❤️ [ProfileScreen] Favorites onTap');
              Navigator.of(context).pushNamed(AppRoutes.favorites);
            },
          ),
          _MenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Purchases',
            subtitle: 'Make changes to your account',
            trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
            onTap: null,
            disabled: true,
          ),
        ];
        if (userType == UserType.safetyPilot) {
          children.add(
            _MenuItem(
              icon: Icons.person_outline,
              title: 'Safety Pilot Profile',
              subtitle: 'Manage your saved account',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: AppColors.textGray),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
                ],
              ),
              onTap: () {
                debugPrint('🧑‍✈️ [ProfileScreen] Safety Pilot profile pressed');
                _navigateToPilotProfile(UserType.safetyPilot);
              },
            ),
          );
        }
        if (userType == UserType.cfi) {
          children.add(
            _MenuItem(
              icon: Icons.flight,
              title: 'CFI Profile',
              subtitle: 'Manage your informations',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 18, color: AppColors.textGray),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
                ],
              ),
              onTap: () {
                debugPrint('🧑‍✈️ [ProfileScreen] CFI profile pressed');
                _navigateToPilotProfile(UserType.cfi);
              },
            ),
          );
        }
        children.addAll([
          _MenuItem(
            icon: Icons.logout,
            title: 'Log out',
            subtitle: 'Further secure your account for safety',
            titleColor: AppColors.grayPrimary,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
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
                  nav.pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
                },
              );
            },
          ),
          _MenuItem(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            subtitle: 'Further secure your account for safety',
            titleColor: AppColors.grayPrimary,
            trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
            onTap: () async {
              DebugLogger.log('ProfileScreen', 'delete account pressed');
              final nav = Navigator.of(context, rootNavigator: true);
              await ConfirmDialog.show(
                context,
                title: 'Hesabı sil',
                message: 'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
                cancelLabel: 'İptal',
                confirmLabel: 'Hesabı sil',
                confirmIsDestructive: true,
                onConfirm: () async {
                  await AuthService.instance.deleteAccount();
                  if (!context.mounted) return;
                  nav.pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
                },
              );
            },
          ),
        ]);
        return _MenuSection(children: children);
      },
    );
  }

  Widget _buildMoreSection() {
    final svc = SettingsApiService.instance;
    return _MenuSection(
      children: [
        _MenuItem(
          icon: Icons.gavel_outlined,
          title: 'Legal',
          subtitle: 'Terms, Privacy, Data Protection',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          onTap: () {
            debugPrint('📜 [ProfileScreen] Legal pressed - show bottom sheet or navigate');
            _showLegalSheet(context);
          },
        ),
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          onTap: () {
            debugPrint('🆘 [ProfileScreen] help pressed');
            Navigator.of(context).pushNamed(
              AppRoutes.helpSupport,
              arguments: {
                'contact_address': svc.contactAddress(_settings),
                'contact_email': svc.contactEmail(_settings),
                'contact_phone': svc.contactPhone(_settings),
                'contact_whatsapp': svc.contactWhatsapp(_settings),
                'support_email': svc.supportEmail(_settings),
              },
            );
          },
        ),
        _MenuItem(
          icon: Icons.info_outline,
          title: 'About App',
          trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
          onTap: () {
            debugPrint('ℹ️ [ProfileScreen] about pressed');
            final version = svc.appVersion(_settings) ?? '1.0.0+1';
            Navigator.of(context).pushNamed(
              AppRoutes.aboutApp,
              arguments: {'app_version': version},
            );
          },
        ),
      ],
    );
  }

  void _showLegalSheet(BuildContext context) {
    final svc = SettingsApiService.instance;
    final terms = svc.termsOfService(_settings);
    final privacy = svc.privacyPolicy(_settings);
    final kvkk = svc.kvkkText(_settings);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Legal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.labelBlack),
                ),
                const SizedBox(height: 16),
                _LegalTile(
                  title: 'Terms of Service',
                  html: terms,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.htmlContent,
                      arguments: {'title': 'Terms of Service', 'html': terms ?? '<p>İçerik henüz eklenmedi.</p>'},
                    );
                  },
                ),
                _LegalTile(
                  title: 'Privacy Protection',
                  html: privacy,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.htmlContent,
                      arguments: {'title': 'Privacy Protection', 'html': privacy ?? '<p>İçerik henüz eklenmedi.</p>'},
                    );
                  },
                ),
                _LegalTile(
                  title: 'Data Protection',
                  html: kvkk,
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.htmlContent,
                      arguments: {'title': 'Data Protection', 'html': kvkk ?? '<p>İçerik henüz eklenmedi.</p>'},
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterWidget() {
    final text = SettingsApiService.instance.footerText(_settings) ?? '';
    final displayText = text.trim().isEmpty ? 'Skye © 2025 – Aviation community' : text;
    debugPrint('👤 [ProfileScreen] _buildFooterWidget footer_text: ${displayText.length} chars (mock: ${text.isEmpty})');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textGrayMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  const _LegalTile({
    required this.title,
    required this.html,
    required this.onTap,
  });

  final String title;
  final String? html;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.labelBlack,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textGray, size: 20),
      onTap: onTap,
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
            if (isSelected) const Icon(Icons.check_circle, size: 22, color: AppColors.navy800),
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
    this.disabled = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final opacity = disabled ? 0.5 : 1.0;
    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.cardLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.labelBlack),
              ),
              const SizedBox(width: 16),
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
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
