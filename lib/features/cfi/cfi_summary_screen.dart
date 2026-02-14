import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_form_data_holder.dart';
import 'package:skye_app/features/cfi/cfi_in_review_screen.dart';
import 'package:skye_app/shared/services/auth_api_service.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';

class CfiSummaryScreen extends StatefulWidget {
  const CfiSummaryScreen({
    super.key,
    required this.formData,
  });

  static const routeName = '/cfi/summary';

  final Map<String, dynamic> formData;

  @override
  State<CfiSummaryScreen> createState() => _CfiSummaryScreenState();
}

class _CfiSummaryScreenState extends State<CfiSummaryScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CfiSummaryScreen', 'build()');

    return BaseFormScreen(
      title: 'Summary',
      subtitle: 'Please review your information before submitting',
      currentStep: 4,
      totalSteps: 4,
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 24),

        // Profile Section (Create CFI Profile)
        _buildSection(
          'Profile',
          [
            _buildInfoRow('Spoken Languages', _getSpokenLanguagesValue()),
            _buildInfoRow('License Number', _getStringValue(widget.formData['license_number'])),
            _buildInfoRow('State', _getStringValue(widget.formData['state'])),
            _buildInfoRow('City', _getStringValue(widget.formData['city'])),
            _buildInfoRow('Address', _getStringValue(widget.formData['address'])),
            _buildInfoRow('Base Airport(s)', _getStringValue(widget.formData['base_airport'])),
          ],
        ),

        const SizedBox(height: 24),

        // Information Section
        _buildSection(
          'Information',
          [
            _buildInfoRow('Hourly Rate', widget.formData['hourly_rate'] != null ? '\$${widget.formData['hourly_rate']}' : '—'),
            _buildInfoRow('Instructor Ratings', _getListValue(widget.formData['instructor_ratings'])),
            _buildInfoRow('Other Licenses', _getListValue(widget.formData['other_licenses'])),
            _buildInfoRow('Minimum Booking', _getStringValue(widget.formData['minimum_booking'])),
            _buildInfoRow('Aircraft Ownership', _getStringValue(widget.formData['aircraft_ownership'])),
            _buildInfoRow(
              'Selected Aircraft',
              _getSelectedAircraftsValue(widget.formData['selected_aircrafts']),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Experiences Section
        _buildSection(
          'Experiences',
          [
            _buildInfoRow('Total Flight Hours', _getStringValue(widget.formData['total_flight_hours_exp'])),
            _buildInfoRow('Total Given Hours', _getStringValue(widget.formData['total_given_hours'])),
            _buildInfoRow('Last 12 Months Dual Hours', _getStringValue(widget.formData['last_12_months_dual_hours'])),
            _buildInfoRow('About me', _getStringValue(widget.formData['notes'])),
            _buildAircraftExperiencesBlock(widget.formData['aircraft_experiences']),
          ],
        ),

        const SizedBox(height: 24),

        // Submit button
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
    final s = value.toString().trim();
    return s.isEmpty ? '—' : s;
  }

  String _getListValue(dynamic value) {
    if (value == null) return '—';
    if (value is! List || value.isEmpty) return '—';
    return value.map((e) => e.toString()).join(', ');
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

  Widget _buildAircraftExperiencesBlock(dynamic value) {
    final list = value is List ? value : <dynamic>[];
    return Container(
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
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack4,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.selectedBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.labelBlack,
                ),
              ),
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
      decoration: BoxDecoration(
        color: AppColors.cfiBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.labelBlack60,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.labelBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateRequiredFields() {
    final requiredFields = <String, String>{
      'license_number': 'License Number',
      'base_airport': 'Base Airport',
      'state': 'State',
      'city': 'City',
      'address': 'Address',
      'hourly_rate': 'Hourly Rate',
    };

    final missingFields = <String>[];
    for (final entry in requiredFields.entries) {
      final value = widget.formData[entry.key];
      if (value == null || 
          value.toString().isEmpty || 
          (value is int && value == 0 && entry.key != 'hourly_rate')) {
        missingFields.add(entry.value);
      }
    }

    if (missingFields.isNotEmpty) {
      ToastOverlay.show(context, 'Please fill in all required fields: ${missingFields.join(', ')}');
      return false;
    }
    return true;
  }

  Future<void> _handleSubmit() async {
    // Validate required fields before submitting
    if (!_validateRequiredFields()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      DebugLogger.log('CfiSummaryScreen', 'Submitting application', widget.formData);

      // POST /api/pilot/applications - pilot_type: "pilot" (CFI/Instructor)
      final exps = (widget.formData['aircraft_experiences'] as List?) ?? [];
      final aircraftTypes = <int>[];
      final aircraftHours = <int>[];
      final aircraftOwns = <bool>[];
      final owns = widget.formData['aircraft_ownership'] == 'Yes';
      for (final e in exps) {
        if (e is Map) {
          final typeId = int.tryParse(e['type']?.toString() ?? '');
          aircraftTypes.add(typeId ?? 0);
          aircraftHours.add(int.tryParse(e['hours']?.toString() ?? '') ?? 0);
          aircraftOwns.add(owns);
        }
      }

      final submitData = <String, dynamic>{
        'pilot_type': 'pilot',
        'package_id': widget.formData['package_id'],
        'state_id': int.tryParse(widget.formData['state_id']?.toString() ?? '') ?? 1,
        'city_id': int.tryParse(widget.formData['city_id']?.toString() ?? '') ?? 101,
        'airport_ids': (widget.formData['airport_ids'] as List?) ?? [],
        'phone_number': widget.formData['phone_number']?.toString() ?? '',
        'about': widget.formData['notes']?.toString() ?? '',
        'license_number': widget.formData['license_number']?.toString() ?? '',
        'address': widget.formData['address']?.toString() ?? '',
        'hourly_rate': int.tryParse(widget.formData['hourly_rate']?.toString() ?? '') ?? 0,
        'minimum_booking': widget.formData['minimum_booking']?.toString() ?? '',
        'spoken_languages': widget.formData['spoken_languages'] ?? [],
        'instructor_ratings': widget.formData['instructor_ratings'] ?? [],
        'other_licenses': widget.formData['other_licenses'] ?? [],
        'aircraft_experience_types': aircraftTypes,
        'aircraft_experience_hours': aircraftHours,
        'aircraft_experience_owns': aircraftOwns,
        'notes': widget.formData['notes']?.toString() ?? '',
      };

      submitData['base_airport'] = widget.formData['base_airport']?.toString() ?? '';
      submitData['country'] = widget.formData['state']?.toString() ?? '';
      submitData['city'] = widget.formData['city']?.toString() ?? '';
      submitData['total_flight_hours'] = int.tryParse(widget.formData['total_flight_hours_exp']?.toString() ?? widget.formData['total_flight_hours']?.toString() ?? '') ?? 0;

      // Try to get phone from auth user
      try {
        final user = await AuthApiService.instance.getMe();
        final phone = user['phone'] ?? user['phone_number']?.toString();
        if (phone != null && phone.toString().isNotEmpty) {
          submitData['phone_number'] = phone.toString();
        }
      } catch (_) {}
      
      DebugLogger.log('CfiSummaryScreen', 'Submitting with data', submitData);

      await PilotApiService.instance.submitApplication(submitData);

      if (mounted) {
        CfiFormDataHolder.clear(); // Clear after successful submit
        // Navigate to in-review screen
        Navigator.of(context).pushReplacementNamed(CfiInReviewScreen.routeName);
      }
    } catch (e) {
      DebugLogger.log('CfiSummaryScreen', 'Submit error', {'error': e.toString()});
      if (mounted) {
        String errorMessage = 'Failed to submit application';
        String? detailedError;
        
        // Parse DioException to show better error message
        if (e is DioException && e.response != null) {
          final responseData = e.response?.data;
          if (responseData is Map<String, dynamic>) {
            final errors = responseData['errors'] as Map<String, dynamic>?;
            if (errors != null) {
              final errorList = <String>[];
              errors.forEach((key, value) {
                if (value is List && value.isNotEmpty) {
                  errorList.add('${key}: ${value.first}');
                }
              });
              if (errorList.isNotEmpty) {
                errorMessage = 'Validation error: ${errorList.join(', ')}';
                
                // Check if it's package_id or pilot_type error
                if (errors.containsKey('package_id') || errors.containsKey('pilot_type')) {
                  detailedError = 'Backend API hatası: package_id ve pilot_type için geçerli değerler gerekiyor.\n\n'
                      'Backend ekibine sorulacaklar:\n'
                      '1. POST /api/pilot/applications için geçerli package_id değerleri nelerdir? (şu an 1 ve 2 reddediliyor)\n'
                      '2. pilot_type için kabul edilen değerler nelerdir? (şu an "instructor", "CFI", "cfi" reddediliyor)\n'
                      '3. Bu değerleri almak için bir API endpoint\'i var mı? (örn: GET /api/packages, GET /api/pilot-types)\n'
                      '4. Zorunlu alanlar: package_id*, pilot_type*, desired_level*, license_number*, base_airport*, country*, city*, address*, experience_years*, total_flight_hours*, hourly_rate*';
                }
              }
            } else if (responseData['message'] != null) {
              errorMessage = responseData['message'].toString();
            }
          }
        } else {
          errorMessage = e.toString();
        }
        
        final msg = detailedError != null
            ? '$errorMessage\n$detailedError'
            : errorMessage;
        ToastOverlay.show(context, msg);
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
