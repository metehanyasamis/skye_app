import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/widgets/base_form_screen.dart';
import 'package:skye_app/widgets/booking_chips.dart';
import 'package:skye_app/widgets/hourly_rate_selector.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/rating_chips.dart';

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
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Ratings',
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
            selected: _selectedRatings,
            onSelectionChanged: (selected) {
              DebugLogger.log('SafetyPilotInformationsScreen', 'ratings changed', {'selected': selected.toList()});
              setState(() {
                _selectedRatings.clear();
                _selectedRatings.addAll(selected);
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
              DebugLogger.log('SafetyPilotInformationsScreen', 'otherLicenses changed', {'selected': selected.toList()});
              setState(() {
                _selectedOtherLicenses.clear();
                _selectedOtherLicenses.addAll(selected);
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
              DebugLogger.log('SafetyPilotInformationsScreen', 'hourlyRate selected', {'rate': rate});
              setState(() {
                _selectedHourlyRate = rate;
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
              DebugLogger.log('SafetyPilotInformationsScreen', 'aircraftOwnership selected', {'selected': selected});
              setState(() {
                _selectedAircraftOwnership = selected;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Submit button
        PrimaryButton(
          label: 'Submit',
          onPressed: () {
            DebugLogger.log('SafetyPilotInformationsScreen', 'Submit pressed');
            // TODO: Submit form
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

