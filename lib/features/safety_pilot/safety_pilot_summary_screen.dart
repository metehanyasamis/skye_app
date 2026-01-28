import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/app/routes/app_routes.dart';
import 'package:skye_app/shared/services/safety_pilot_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

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
      children: [
        _buildSection(
          'Information',
          [
            if (_v('license_number') != null) _buildInfoRow('License Number', _v('license_number')!),
            if (_v('base_airport') != null) _buildInfoRow('Base Airport', _v('base_airport')!),
            if (_v('country') != null) _buildInfoRow('Country', _v('country')!),
            if (_v('city') != null) _buildInfoRow('City', _v('city')!),
            if (_v('address') != null) _buildInfoRow('Address', _v('address')!),
            if (_v('spoken_languages') != null) _buildInfoRow('Spoken Languages', _v('spoken_languages')!),
            if (_list('ratings') != null && _list('ratings')!.isNotEmpty)
              _buildInfoRow('Ratings', (_list('ratings')!).map((e) => e.toString()).join(', ')),
            if (_list('other_licenses') != null && _list('other_licenses')!.isNotEmpty)
              _buildInfoRow('Other Licenses', (_list('other_licenses')!).map((e) => e.toString()).join(', ')),
            if (_v('hourly_rate') != null) _buildInfoRow('Hourly Rate', '\$${_v('hourly_rate')}'),
            if (_v('aircraft_ownership') != null) _buildInfoRow('Aircraft Ownership', _v('aircraft_ownership')!),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          'Experiences',
          [
            if (_v('total_flight_hours') != null) _buildInfoRow('Total Flight Hours', _v('total_flight_hours')!),
            if (_list('aircraft_experiences') != null && _list('aircraft_experiences')!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blueInfoLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.blueInfo.withValues(alpha: 0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Aircraft Type Experience',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.labelBlack),
                    ),
                    const SizedBox(height: 12),
                    ...(_list('aircraft_experiences')!.map((e) {
                      final type = e['type']?.toString() ?? '';
                      final hours = e['hours']?.toString() ?? '';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.selectedBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(type, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.selectedBlue)),
                            ),
                            const Spacer(),
                            Text('$hours hours', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.labelBlack)),
                          ],
                        ),
                      );
                    })),
                  ],
                ),
              ),
            ],
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

  String? _v(String key) {
    final v = widget.formData[key];
    if (v == null) return null;
    if (v is List) return v.join(', ');
    return v.toString().trim().isEmpty ? null : v.toString();
  }

  List<dynamic>? _list(String key) {
    final v = widget.formData[key];
    if (v == null || v is! List) return null;
    return v.isEmpty ? null : v;
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
    if (value.isEmpty) return const SizedBox.shrink();
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
      final data = <String, dynamic>{
        'license_number': widget.formData['license_number']?.toString() ?? '',
        'base_airport': widget.formData['base_airport']?.toString() ?? '',
        'country': widget.formData['country']?.toString() ?? '',
        'city': widget.formData['city']?.toString() ?? '',
        'address': widget.formData['address']?.toString() ?? '',
        'spoken_languages': widget.formData['spoken_languages'] ?? [],
        'ratings': widget.formData['ratings'] ?? [],
        'other_licenses': widget.formData['other_licenses'] ?? [],
        'hourly_rate': int.tryParse(widget.formData['hourly_rate']?.toString() ?? '') ?? 0,
        'aircraft_ownership': widget.formData['aircraft_ownership']?.toString() ?? '',
        'total_flight_hours': int.tryParse(widget.formData['total_flight_hours']?.toString() ?? '') ?? 0,
        'aircraft_experiences': (widget.formData['aircraft_experiences'] as List?)?.map((e) {
          return {'type': e['type'] ?? '', 'hours': int.tryParse(e['hours']?.toString() ?? '') ?? 0};
        }).toList() ?? [],
      };

      await SafetyPilotApiService.instance.submitApplication(data);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.safetyPilotInReview);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final status = e.response?.statusCode;
      // Backend not ready: 404/501 → still navigate to In Review for demo
      if (status == 404 || status == 501) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Backend not ready yet. Simulated submission – you can continue.'),
              backgroundColor: Colors.orange,
            ),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.safetyPilotInReview);
        }
        return;
      }
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $msg'), backgroundColor: Colors.red),
      );
      debugPrint('❌ [SafetyPilotSummaryScreen] Submit error: $e');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submit failed: $e'), backgroundColor: Colors.red),
      );
      debugPrint('❌ [SafetyPilotSummaryScreen] Submit error: $e');
    }
  }
}
