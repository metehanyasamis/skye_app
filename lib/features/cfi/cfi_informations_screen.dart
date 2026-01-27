import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_experiences_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/booking_chips.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/rating_chips.dart';

class CfiInformationsScreen extends StatefulWidget {
  const CfiInformationsScreen({super.key});

  static const routeName = '/cfi/informations';

  @override
  State<CfiInformationsScreen> createState() => _CfiInformationsScreenState();
}

class _CfiInformationsScreenState extends State<CfiInformationsScreen> {
  final _experienceYearsController = TextEditingController();
  final _totalFlightHoursController = TextEditingController();
  
  final Set<String> _selectedInstructorRatings = {};
  final Set<String> _selectedOtherLicenses = {};
  int _selectedHourlyRate = 20;
  String? _selectedMinimumBooking;
  String? _selectedAircraftOwnership;

  Map<String, dynamic> _formData = {};
  bool _hasLoadedFormData = false;

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CfiInformationsScreen', 'initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get form data from previous screen - must be in didChangeDependencies, not initState
    if (!_hasLoadedFormData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _formData = Map<String, dynamic>.from(args);
        _hasLoadedFormData = true;
      }
    }
  }

  @override
  void dispose() {
    _experienceYearsController.dispose();
    _totalFlightHoursController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    // TODO: Re-enable validation later
    // Validate required fields
    // if (_experienceYearsController.text.isEmpty) return false;
    // if (_totalFlightHoursController.text.isEmpty) return false;
    // if (_selectedHourlyRate == 0) return false;
    return true; // Temporarily disabled for testing
  }

  void _handleNextPage() {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    DebugLogger.log('CfiInformationsScreen', 'Next Page pressed', {
      'instructorRatings': _selectedInstructorRatings.toList(),
      'otherLicenses': _selectedOtherLicenses.toList(),
      'experienceYears': _experienceYearsController.text,
      'totalFlightHours': _totalFlightHoursController.text,
      'hourlyRate': _selectedHourlyRate,
      'minimumBooking': _selectedMinimumBooking,
      'aircraftOwnership': _selectedAircraftOwnership,
    });

    // Get form data from previous screen (if any)
    final previousData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    
    // Collect current screen data
    final formData = <String, dynamic>{
      ...previousData,
      'instructor_ratings': _selectedInstructorRatings.toList(),
      'other_licenses': _selectedOtherLicenses.toList(),
      'experience_years': _experienceYearsController.text,
      'total_flight_hours': _totalFlightHoursController.text,
      'hourly_rate': _selectedHourlyRate.toString(),
      'minimum_booking': _selectedMinimumBooking ?? '',
      'aircraft_ownership': _selectedAircraftOwnership ?? '',
    };

    // Navigate to experiences screen with form data
    Navigator.of(context).pushNamed(
      CfiExperiencesScreen.routeName,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CfiInformationsScreen', 'build()');

    return BaseFormScreen(
      title: 'Informations',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 2,
      totalSteps: 4,
      children: [
        // Experience years - required
        FormFieldWithIcon(
          label: 'Experience years',
          icon: Icons.calendar_today,
          controller: _experienceYearsController,
          fillColor: AppColors.white,
          isRequired: true,
          keyboardType: TextInputType.number,
          onChanged: (v) => DebugLogger.log('CfiInformationsScreen', 'experienceYears changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Total flight hours - required
        FormFieldWithIcon(
          label: 'Total flight hours',
          icon: Icons.flight,
          controller: _totalFlightHoursController,
          fillColor: AppColors.white,
          isRequired: true,
          keyboardType: TextInputType.number,
          onChanged: (v) => DebugLogger.log('CfiInformationsScreen', 'totalFlightHours changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Instructor ratings section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Instructor ratings',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: RatingChips(
            options: const ['CFI', 'MEI', 'CPL', ''],
            selected: _selectedInstructorRatings,
            onSelectionChanged: (selected) {
              DebugLogger.log('CfiInformationsScreen', 'instructorRatings changed', {'selected': selected.toList()});
              setState(() {
                _selectedInstructorRatings
                  ..clear()
                  ..addAll(selected);
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Other licenses section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Other licenses',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: RatingChips(
            options: const ['PPL', 'IR', 'CPL', ''],
            selected: _selectedOtherLicenses,
            onSelectionChanged: (selected) {
              DebugLogger.log('CfiInformationsScreen', 'otherLicenses changed', {'selected': selected.toList()});
              setState(() {
                _selectedOtherLicenses
                  ..clear()
                  ..addAll(selected);
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Hourly rate section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Hourly rate (\$)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: HourlyRateSelector(
            selectedRate: _selectedHourlyRate,
            onRateSelected: (rate) {
              DebugLogger.log('CfiInformationsScreen', 'hourlyRate changed', {'rate': rate});
              setState(() {
                _selectedHourlyRate = rate;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Minimum booking section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Minimum booking',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: BookingChips(
            options: const ['1 Hour', '3 Hours', '1 Day', 'Always'],
            selected: _selectedMinimumBooking,
            onSelectionChanged: (selected) {
              DebugLogger.log('CfiInformationsScreen', 'minimumBooking changed', {'selected': selected});
              setState(() {
                _selectedMinimumBooking = selected;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Aircraft ownership section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Aircraft ownership',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: BookingChips(
            options: const ['Yes', 'No'],
            selected: _selectedAircraftOwnership,
            onSelectionChanged: (selected) {
              DebugLogger.log('CfiInformationsScreen', 'aircraftOwnership changed', {'selected': selected});
              setState(() {
                _selectedAircraftOwnership = selected;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: _handleNextPage,
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
