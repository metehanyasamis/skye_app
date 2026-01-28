import 'package:flutter/material.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_experiences_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/booking_chips.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/rating_chips.dart';

class SafetyPilotInformationsScreen extends StatefulWidget {
  const SafetyPilotInformationsScreen({super.key});

  static const routeName = '/safety-pilot/informations';

  @override
  State<SafetyPilotInformationsScreen> createState() =>
      _SafetyPilotInformationsScreenState();
}

class _SafetyPilotInformationsScreenState
    extends State<SafetyPilotInformationsScreen> {
  final Set<String> _selectedRatings = {'CFI', 'MEI'};
  final Set<String> _selectedOtherLicenses = {'PPL', 'IR'};
  int _selectedHourlyRate = 12;
  String? _selectedAircraftOwnership = 'No';

  Map<String, dynamic> _formData = {};
  bool _hasLoadedFormData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedFormData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _formData = Map<String, dynamic>.from(args);
        _hasLoadedFormData = true;
      }
    }
  }

  void _handleNextPage() {
    DebugLogger.log('SafetyPilotInformationsScreen', 'Next Page pressed');
    final formData = <String, dynamic>{
      ..._formData,
      'ratings': _selectedRatings.toList(),
      'other_licenses': _selectedOtherLicenses.toList(),
      'hourly_rate': _selectedHourlyRate.toString(),
      'aircraft_ownership': _selectedAircraftOwnership ?? '',
    };
    Navigator.of(context).pushNamed(
      SafetyPilotExperiencesScreen.routeName,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('SafetyPilotInformationsScreen', 'build()');

    return BaseFormScreen(
      title: 'Informations',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 2,
      totalSteps: 4,
      children: [
        // Ratings section
        const Text(
          'Ratings',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.labelBlack,
            height: 24 / 14,
          ),
        ),
        const SizedBox(height: 16),
        RatingChips(
          options: const ['CFI', 'MEI', 'CPL', ''],
          selected: _selectedRatings,
          onSelectionChanged: (selected) {
            DebugLogger.log('SafetyPilotInformationsScreen', 'ratings changed', {'selected': selected.toList()});
            setState(() {
              _selectedRatings.clear();
              _selectedRatings.addAll(selected);
            });
          },
        ),

        const SizedBox(height: 40),

        // Other licenses section
        const Text(
          'Other licenses',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.labelBlack,
            height: 24 / 14,
          ),
        ),
        const SizedBox(height: 16),
        RatingChips(
          options: const ['PPL', 'IR', 'CPL', ''],
          selected: _selectedOtherLicenses,
          onSelectionChanged: (selected) {
            DebugLogger.log('SafetyPilotInformationsScreen', 'otherLicenses changed', {'selected': selected.toList()});
            setState(() {
              _selectedOtherLicenses.clear();
              _selectedOtherLicenses.addAll(selected);
            });
          },
        ),

        const SizedBox(height: 40),

        // Hourly rate section
        const Text(
          'Hourly rate (\$)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.labelBlack,
            height: 24 / 14,
          ),
        ),
        const SizedBox(height: 16),
        HourlyRateSelector(
          selectedRate: _selectedHourlyRate,
          onRateSelected: (rate) {
            DebugLogger.log('SafetyPilotInformationsScreen', 'hourlyRate selected', {'rate': rate});
            setState(() {
              _selectedHourlyRate = rate;
            });
          },
        ),

        const SizedBox(height: 40),

        // Aircraft ownership section
        const Text(
          'Aircraft ownership',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.labelBlack,
            height: 24 / 14,
          ),
        ),
        const SizedBox(height: 16),
        BookingChips(
          options: const ['Yes', 'No'],
          selected: _selectedAircraftOwnership,
          onSelectionChanged: (selected) {
            DebugLogger.log('SafetyPilotInformationsScreen', 'aircraftOwnership selected', {'selected': selected});
            setState(() {
              _selectedAircraftOwnership = selected;
            });
          },
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

