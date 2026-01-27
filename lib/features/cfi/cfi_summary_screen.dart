import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_in_review_screen.dart';
import 'package:skye_app/shared/services/pilot_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

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
      children: [
        // Information Section
        _buildSection(
          'Information',
          [
            if (widget.formData['license_number'] != null)
              _buildInfoRow('License Number', widget.formData['license_number']),
            if (widget.formData['base_airport'] != null)
              _buildInfoRow('Base Airport', widget.formData['base_airport']),
            if (widget.formData['country'] != null)
              _buildInfoRow('Country', widget.formData['country']),
            if (widget.formData['city'] != null)
              _buildInfoRow('City', widget.formData['city']),
            if (widget.formData['address'] != null)
              _buildInfoRow('Address', widget.formData['address']),
            if (widget.formData['experience_years'] != null)
              _buildInfoRow('Experience Years', widget.formData['experience_years']),
            if (widget.formData['total_flight_hours'] != null)
              _buildInfoRow('Total Flight Hours', widget.formData['total_flight_hours']),
            if (widget.formData['hourly_rate'] != null)
              _buildInfoRow('Hourly Rate', '\$${widget.formData['hourly_rate']}'),
            if (widget.formData['spoken_languages'] != null && (widget.formData['spoken_languages'] as List).isNotEmpty)
              _buildInfoRow('Spoken Languages', (widget.formData['spoken_languages'] as List).join(', ')),
            if (widget.formData['instructor_ratings'] != null && (widget.formData['instructor_ratings'] as List).isNotEmpty)
              _buildInfoRow('Instructor Ratings', (widget.formData['instructor_ratings'] as List).join(', ')),
            if (widget.formData['other_licenses'] != null && (widget.formData['other_licenses'] as List).isNotEmpty)
              _buildInfoRow('Other Licenses', (widget.formData['other_licenses'] as List).join(', ')),
            if (widget.formData['minimum_booking'] != null)
              _buildInfoRow('Minimum Booking', widget.formData['minimum_booking']),
            if (widget.formData['aircraft_ownership'] != null)
              _buildInfoRow('Aircraft Ownership', widget.formData['aircraft_ownership']),
            if (widget.formData['notes'] != null && widget.formData['notes'].toString().isNotEmpty)
              _buildInfoRow('Notes', widget.formData['notes']),
          ],
        ),

        const SizedBox(height: 24),

        // Experiences Section
        _buildSection(
          'Experiences',
          [
            if (widget.formData['total_flight_hours_exp'] != null)
              _buildInfoRow('Total Flight Hours', widget.formData['total_flight_hours_exp']),
            if (widget.formData['total_given_hours'] != null)
              _buildInfoRow('Total Given Hours', widget.formData['total_given_hours']),
            if (widget.formData['last_12_months_dual_hours'] != null)
              _buildInfoRow('Last 12 Months Dual Hours', widget.formData['last_12_months_dual_hours']),
            if (widget.formData['aircraft_experiences'] != null && (widget.formData['aircraft_experiences'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
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
                    ...(widget.formData['aircraft_experiences'] as List).map((exp) {
                      final type = exp['type'] ?? '';
                      final hours = exp['hours'] ?? '';
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
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.selectedBlue,
                                ),
                              ),
                            ),
                            const Spacer(),
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
              ),
            ],
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
    if (value.isEmpty || value == 'null') {
      return const SizedBox.shrink();
    }
    
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
      'country': 'Country',
      'city': 'City',
      'address': 'Address',
      'experience_years': 'Experience Years',
      'total_flight_hours': 'Total Flight Hours',
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields: ${missingFields.join(', ')}'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 4),
        ),
      );
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

      // Prepare data for backend
      // NOTE: Backend requires these fields (marked with *):
      // package_id*, pilot_type*, desired_level*, license_number*, base_airport*,
      // country*, city*, address*, experience_years*, total_flight_hours*, hourly_rate*
      // TODO: Get valid package_id and pilot_type from backend API
      final submitData = <String, dynamic>{
        // Backend requires package_id - need valid ID from backend
        // TODO: Replace with actual package_id from backend API
        'package_id': widget.formData['package_id'] ?? 2, // Placeholder - needs valid value
        // Backend requires pilot_type - need valid value from backend
        // TODO: Replace with actual pilot_type from backend API
        'pilot_type': 'cfi', // Placeholder - needs valid value
        'desired_level': widget.formData['desired_level'] ?? 'CFI',
        'license_number': widget.formData['license_number']?.toString() ?? '',
        'base_airport': widget.formData['base_airport']?.toString() ?? '',
        'country': widget.formData['country']?.toString() ?? '',
        'city': widget.formData['city']?.toString() ?? '',
        'address': widget.formData['address']?.toString() ?? '',
        'experience_years': int.tryParse(widget.formData['experience_years']?.toString() ?? '') ?? 0,
        'total_flight_hours': int.tryParse(widget.formData['total_flight_hours']?.toString() ?? '') ?? 0,
        'hourly_rate': int.tryParse(widget.formData['hourly_rate']?.toString() ?? '') ?? 0,
        'notes': widget.formData['notes']?.toString() ?? '',
        'spoken_languages': widget.formData['spoken_languages'] ?? [],
        'instructor_ratings': widget.formData['instructor_ratings'] ?? [],
        'other_licenses': widget.formData['other_licenses'] ?? [],
        'aircraft_experiences': (widget.formData['aircraft_experiences'] as List?)?.map((e) {
          return {
            'aircraft_type': e['type'] ?? '',
            'hours': int.tryParse(e['hours']?.toString() ?? '') ?? 0,
            'owns_aircraft': widget.formData['aircraft_ownership'] == 'Yes',
          };
        }).toList() ?? [],
      };
      
      DebugLogger.log('CfiSummaryScreen', 'Submitting with data', submitData);

      await PilotApiService.instance.submitApplication(submitData);

      if (mounted) {
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
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (detailedError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    detailedError!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
