import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skye_app/shared/services/settings_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// Help & Support - contact information from backend
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  static const routeName = '/profile/help-support';

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  Map<String, dynamic> _settings = {};
  bool _loading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _load();
    }
  }

  Future<void> _load() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null &&
        (args['contact_address'] != null ||
            args['contact_email'] != null ||
            args['contact_phone'] != null)) {
      if (mounted) {
        setState(() {
          _settings = args;
          _loading = false;
        });
      }
      return;
    }
    try {
      final s = await SettingsApiService.instance.getSettings();
      if (mounted) {
        setState(() {
          _settings = s;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ [HelpSupportScreen] load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    final bottom = MediaQuery.of(context).padding.bottom + 24;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottom),
      ),
    );
  }

  Future<void> _openEmail(String email) async {
    debugPrint('📧 [HelpSupportScreen] openEmail: $email');
    try {
      final uri = Uri.parse('mailto:$email');
      final launched = await launchUrl(uri);
      if (!launched && mounted) _showSnack('No email app configured');
    } catch (e) {
      debugPrint('❌ [HelpSupportScreen] openEmail error: $e');
      if (mounted) _showSnack('No email app configured');
    }
  }

  Future<void> _openPhone(String phone) async {
    debugPrint('📞 [HelpSupportScreen] openPhone: $phone');
    final clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.isEmpty) return;
    try {
      final uri = Uri.parse('tel:${clean.startsWith('+') ? clean : '+$clean'}');
      final launched = await launchUrl(uri);
      if (!launched && mounted) _showSnack('Cannot open dialer');
    } catch (e) {
      debugPrint('❌ [HelpSupportScreen] openPhone error: $e');
      if (mounted) _showSnack('Cannot open dialer');
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    debugPrint('💬 [HelpSupportScreen] openWhatsApp: $phone');
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.isEmpty) return;
    try {
      final uri = Uri.parse('https://wa.me/$clean');
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) _showSnack('WhatsApp not available');
    } catch (e) {
      debugPrint('❌ [HelpSupportScreen] openWhatsApp error: $e');
      if (mounted) _showSnack('WhatsApp not available');
    }
  }

  void _openAddress(BuildContext context, String address) {
    debugPrint('📍 [HelpSupportScreen] openAddress: $address');
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Open in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelBlack,
                ),
              ),
              const SizedBox(height: 12),
              if (Platform.isIOS) ...[
                _MapOptionTile(
                  label: 'Apple Maps',
                  onTap: () {
                    Navigator.pop(ctx);
                    _launchMapUrl('https://maps.apple.com/?q=${Uri.encodeComponent(address)}');
                  },
                ),
              ],
              _MapOptionTile(
                label: 'Google Maps',
                onTap: () {
                  Navigator.pop(ctx);
                  _launchMapUrl('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
                },
              ),
              _MapOptionTile(
                label: 'Yandex Maps',
                onTap: () {
                  Navigator.pop(ctx);
                  _launchMapUrl('https://yandex.com/maps/?text=${Uri.encodeComponent(address)}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchMapUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && mounted) _showSnack('Could not open maps');
    } catch (e) {
      debugPrint('❌ [HelpSupportScreen] _launchMapUrl error: $e');
      if (mounted) _showSnack('Could not open maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🆘 [HelpSupportScreen] build()');
    SystemUIHelper.setLightStatusBar();

    final svc = SettingsApiService.instance;
    final contactAddress = svc.contactAddress(_settings);
    final contactEmail = svc.contactEmail(_settings);
    final contactPhone = svc.contactPhone(_settings);
    final contactWhatsapp = svc.contactWhatsapp(_settings);
    final supportEmail = svc.supportEmail(_settings);

    return Scaffold(
      backgroundColor: AppColors.homeBackground,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
          onPressed: () {
            debugPrint('⬅️ [HelpSupportScreen] Back pressed');
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.labelBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ContactRow(
                  icon: Icons.location_on_outlined,
                  label: 'Contact Address',
                  value: contactAddress ?? '—',
                  onTap: contactAddress != null && contactAddress != '—'
                      ? () => _openAddress(context, contactAddress!)
                      : null,
                ),
                _ContactRow(
                  icon: Icons.email_outlined,
                  label: 'Contact Email',
                  value: contactEmail ?? '—',
                  onTap: contactEmail != null && contactEmail != '—'
                      ? () => _openEmail(contactEmail!)
                      : null,
                ),
                _ContactRow(
                  icon: Icons.phone_outlined,
                  label: 'Contact Phone',
                  value: contactPhone ?? '—',
                  onTap: contactPhone != null && contactPhone != '—'
                      ? () => _openPhone(contactPhone!)
                      : null,
                ),
                _ContactRow(
                  icon: Icons.chat_outlined,
                  label: 'Contact WhatsApp',
                  value: contactWhatsapp ?? '—',
                  onTap: contactWhatsapp != null && contactWhatsapp != '—'
                      ? () => _openWhatsApp(contactWhatsapp!)
                      : null,
                ),
                _ContactRow(
                  icon: Icons.support_agent_outlined,
                  label: 'Support Email',
                  value: supportEmail ?? '—',
                  onTap: supportEmail != null && supportEmail != '—'
                      ? () => _openEmail(supportEmail!)
                      : null,
                ),
              ],
            ),
    );
  }
}

class _MapOptionTile extends StatelessWidget {
  const _MapOptionTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: AppColors.labelBlack, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textGray),
      onTap: onTap,
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              debugPrint('🆘 [HelpSupportScreen] tap: $label');
              onTap!();
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: AppColors.navy800),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlack,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
