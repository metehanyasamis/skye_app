import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/pilot_model.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tekil pilot/CFI/Safety Pilot detay ekranı.
/// Listing’den gelen pilot id ile GET /api/pilots/{id} kullanır.
class PilotDetailScreen extends StatefulWidget {
  const PilotDetailScreen({
    super.key,
    this.pilot,
    this.pilotId,
  }) : assert(pilot != null || pilotId != null, 'pilot veya pilotId gerekli');

  static const routeName = '/pilot/detail';

  final PilotModel? pilot;
  final int? pilotId;

  @override
  State<PilotDetailScreen> createState() => _PilotDetailScreenState();
}

class _PilotDetailScreenState extends State<PilotDetailScreen> {
  PilotModel? _pilot;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.pilot != null) {
      setState(() {
        _pilot = widget.pilot;
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final id = widget.pilotId!;
      final pilot = await PilotApiService.instance.getPilot(id);
      if (mounted) {
        setState(() {
          _pilot = pilot;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _launchPhone() async {
    final phone = _pilot?.phone;
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final phone = _pilot?.phone;
    if (phone == null || phone.isEmpty) return;
    final clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemUIHelper.setLightStatusBar();

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.cfiBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.cfiBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.textGray, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    final p = _pilot!;
    final profile = p.pilotProfile;
    final name = p.displayName;
    final licenses = profile?.otherLicenses.map((l) => l.licenseCode).join(', ') ?? '—';
    final ratings = profile?.instructorRatings.map((r) => r.ratingCode).join(', ') ?? '—';
    final hours = profile?.totalFlightHours != null ? '${profile!.totalFlightHours}+ hours' : '—';
    final at = profile?.aircraftExperiences.map((e) => e.aircraftType).where((s) => s.isNotEmpty).join(', ');
    final aircraftTypes = (at == null || at.isEmpty) ? '—' : at;
    final rate = profile?.hourlyRate != null ? '\$${profile!.hourlyRate!.toStringAsFixed(0)}' : '—';
    final location = profile?.location ?? profile?.address ?? '—';
    final about = p.about ?? '—';
    final stateCode = '—';

    return Scaffold(
      backgroundColor: AppColors.cfiBackground,
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.labelBlack),
                      onPressed: () {
                        debugPrint('⬅️ [PilotDetailScreen] Back pressed');
                        Navigator.of(context).pop();
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: AppColors.labelBlack),
                      onPressed: () {
                        debugPrint('❤️ [PilotDetailScreen] Favorite pressed');
                      },
                      style: IconButton.styleFrom(
                        minimumSize: const Size(44, 44),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const CircleAvatar(
                backgroundColor: AppColors.cardLight,
                child: Icon(Icons.person, size: 80, color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlack,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Badge(icon: Icons.star, text: profile?.rating?.toStringAsFixed(1) ?? '—'),
                  const SizedBox(width: 8),
                  _Badge(icon: Icons.share, text: stateCode),
                  const SizedBox(width: 8),
                  _Badge(icon: Icons.check_circle, text: 'Aircraft'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ContactButton(icon: Icons.chat, color: const Color(0xFF25D366), onPressed: _launchWhatsApp),
                const SizedBox(width: 8),
                _ContactButton(icon: Icons.phone, color: AppColors.blue500, onPressed: _launchPhone),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.cardLight,
                              child: Icon(Icons.person, color: AppColors.textSecondary),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.labelBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(label: 'Licenses', value: licenses),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoCard(label: 'Instructor Ratings', value: ratings),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          label: 'Experience',
                          value: hours,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          label: 'Aircraft Type',
                          value: aircraftTypes,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                label: 'Rate (per hour)',
                                value: rate,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoCard(label: 'Location', value: location),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(label: 'About', value: about, isFullWidth: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Availability',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.labelBlack,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'Calendar will be displayed here',
                        style: TextStyle(color: AppColors.textGray),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ContactButton(icon: Icons.chat, color: const Color(0xFF25D366), onPressed: _launchWhatsApp),
                      const SizedBox(width: 8),
                      _ContactButton(icon: Icons.phone, color: AppColors.blue500, onPressed: _launchPhone),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.labelBlack),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 10, color: AppColors.labelBlack),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: AppColors.white),
        onPressed: onPressed,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.label,
    required this.value,
    this.isFullWidth = false,
  });

  final String label;
  final String value;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cfiBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.labelBlack),
          ),
        ],
      ),
    );
  }
}
