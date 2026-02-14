import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/safety_pilot_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';

class SafetyPilotSummaryScreen extends StatefulWidget {
  const SafetyPilotSummaryScreen({
    super.key,
    required this.formData,
  });

  static const routeName = '/safety-pilot/summary';

  final Map<String, dynamic> formData;

  @override
  State<SafetyPilotSummaryScreen> createState() => _SafetyPilotSummaryScreenState();
}

class _SafetyPilotSummaryScreenState extends State<SafetyPilotSummaryScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('SafetyPilotSummaryScreen', 'build()');

    return BaseFormScreen(
      title: 'Summary',
      subtitle: 'Please review your information before submitting',
      currentStep: 4,
      totalSteps: 4,
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),
        _buildSection(
          'Profile',
          [
            _buildInfoRow('Spoken Languages', _getSpokenLanguagesValue()),
            _buildInfoRow('License Number', _getStringValue(widget.formData['license_number'])),
            _buildInfoRow('State', _getStringValue(widget.formData['state'] ?? widget.formData['country'])),
            _buildInfoRow('City', _getStringValue(widget.formData['city'])),
            _buildInfoRow('Address', _getStringValue(widget.formData['address'])),
            _buildInfoRow('Base Airport(s)', _getStringValue(widget.formData['base_airport'])),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          'Information',
          [
            _buildInfoRow('Hourly Rate', _getHourlyRateValue()),
            _buildInfoRow('Instructor Ratings', _getListValue(widget.formData['instructor_ratings'] ?? widget.formData['ratings'])),
            _buildInfoRow('Other Licenses', _getListValue(widget.formData['other_licenses'])),
            _buildInfoRow('Aircraft Ownership', _getStringValue(widget.formData['aircraft_ownership'])),
            _buildInfoRow('Selected Aircraft', _getSelectedAircraftsValue(widget.formData['selected_aircrafts'])),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          'Experiences',
          [
            _buildInfoRow('Total Flight Hours', _getStringValue(widget.formData['total_flight_hours_exp'] ?? widget.formData['total_flight_hours'])),
            _buildInfoRow('About me', _getStringValue(widget.formData['notes'])),
            _buildAircraftExperiencesBlock(widget.formData['aircraft_experiences']),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: _isSubmitting ? 'Submitting...' : 'Submit',
          onPressed: _isSubmitting ? null : _handleSubmit,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  String _getStringValue(dynamic value) {
    if (value == null) return '—';
    if (value is List) return value.isEmpty ? '—' : value.join(', ');
    final s = value.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _getListValue(dynamic value) {
    if (value == null) return '—';
    if (value is! List || value.isEmpty) return '—';
    return value.join(', ');
  }

  String _getSpokenLanguagesValue() {
    final display = widget.formData['spoken_languages_display']?.toString().trim();
    if (display != null && display.isNotEmpty) return display;
    return _getListValue(widget.formData['spoken_languages']);
  }

  String _getSelectedAircraftsValue(dynamic value) {
    if (value == null) return '—';
    if (value is! List || value.isEmpty) return '—';
    return value.map((a) => '${a['name'] ?? ''} (${a['code'] ?? ''})').join(', ');
  }

  String _getHourlyRateValue() {
    final v = widget.formData['hourly_rate'];
    if (v == null) return '—';
    final n = int.tryParse(v.toString());
    if (n == null) return '—';
    return '\$$n';
  }

  Widget _buildAircraftExperiencesBlock(dynamic value) {
    final list = value is List ? value : <dynamic>[];
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blueInfoLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blueInfo.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aircraft Type Experience',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.labelBlack,
            ),
          ),
          const SizedBox(height: 12),
          if (list.isEmpty)
            Text(
              '—',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.labelBlack60.withValues(alpha: 0.7),
              ),
            )
          else
            ...list.map<Widget>((exp) {
              final type = exp['type'] ?? '';
              final name = exp['name']?.toString();
              final hours = exp['hours'] ?? '';
              final label = name != null && name.isNotEmpty ? '$name ($type)' : type;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.selectedBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.selectedBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$hours hours',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelBlack,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [BoxShadow(color: AppColors.shadowBlack4, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(color: AppColors.selectedBlue, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.labelBlack)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: AppColors.cfiBackground, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.labelBlack60)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.labelBlack)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);

    try {
      // POST /api/pilot/applications - pilot_type: "safety_pilot"
      final exps = (widget.formData['aircraft_experiences'] as List?) ?? [];
      final aircraftTypes = <int>[];
      final aircraftHours = <int>[];
      final aircraftOwns = <bool>[];
      final owns = widget.formData['aircraft_ownership'] == 'Yes';
      for (final e in exps) {
        if (e is Map) {
          aircraftTypes.add(int.tryParse(e['type']?.toString() ?? '') ?? 0);
          aircraftHours.add(int.tryParse(e['hours']?.toString() ?? '') ?? 0);
          aircraftOwns.add(owns);
        }
      }

      final data = <String, dynamic>{
        'pilot_type': 'safety_pilot',
        'state_id': int.tryParse(widget.formData['state_id']?.toString() ?? '') ?? 1,
        'city_id': int.tryParse(widget.formData['city_id']?.toString() ?? '') ?? 101,
        'airport_ids': (widget.formData['airport_ids'] as List?) ?? [],
        'phone_number': widget.formData['phone_number']?.toString() ?? '',
        'about': widget.formData['notes']?.toString() ?? '',
        'license_number': widget.formData['license_number']?.toString() ?? '',
        'address': widget.formData['address']?.toString() ?? '',
        'hourly_rate': int.tryParse(widget.formData['hourly_rate']?.toString() ?? '') ?? 0,
        'spoken_languages': widget.formData['spoken_languages'] ?? [],
        'instructor_ratings': widget.formData['instructor_ratings'] ?? widget.formData['ratings'] ?? [],
        'other_licenses': widget.formData['other_licenses'] ?? [],
        'aircraft_experience_types': aircraftTypes,
        'aircraft_experience_hours': aircraftHours,
        'aircraft_experience_owns': aircraftOwns,
        'notes': widget.formData['notes']?.toString() ?? '',
        'package_id': null,
      };
      data['base_airport'] = widget.formData['base_airport']?.toString() ?? '';
      data['country'] = widget.formData['state']?.toString() ?? widget.formData['country']?.toString() ?? '';
      data['city'] = widget.formData['city']?.toString() ?? '';
      data['total_flight_hours'] = int.tryParse(widget.formData['total_flight_hours_exp']?.toString() ?? widget.formData['total_flight_hours']?.toString() ?? '') ?? 0;

      try {
        final user = await AuthApiService.instance.getMe();
        final phone = user['phone'] ?? user['phone_number']?.toString();
        if (phone != null && phone.toString().isNotEmpty) {
          data['phone_number'] = phone.toString();
        }
      } catch (_) {}

      await SafetyPilotApiService.instance.submitApplication(data);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.safetyPilotInReview);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final msg = (e.response?.data is Map && (e.response?.data as Map)['message'] != null)
          ? (e.response?.data as Map)['message'].toString()
          : e.response?.data?.toString() ?? e.message ?? 'Request failed';
      ToastOverlay.show(context, msg);
      debugPrint('❌ [SafetyPilotSummaryScreen] Submit error: $e');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ToastOverlay.show(context, 'Submit failed: $e');
      debugPrint('❌ [SafetyPilotSummaryScreen] Submit error: $e');
    }
  }
}
