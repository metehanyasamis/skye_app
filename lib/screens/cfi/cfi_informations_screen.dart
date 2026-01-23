import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/widgets/base_form_screen.dart';
import 'package:skye_app/widgets/booking_chips.dart';
import 'package:skye_app/widgets/hourly_rate_selector.dart';
import 'package:skye_app/widgets/primary_button.dart';
import 'package:skye_app/widgets/rating_chips.dart';

class CfiInformationsScreen extends StatefulWidget {
  const CfiInformationsScreen({super.key});

  static const routeName = '/cfi/informations';

  @override
  State<CfiInformationsScreen> createState() => _CfiInformationsScreenState();
}

class _CfiInformationsScreenState extends State<CfiInformationsScreen> {
  final Set<String> _selectedInstructorRatings = {'CFI', 'MEI'};
  final Set<String> _selectedOtherLicenses = {'PPL', 'IR'};
  int _selectedHourlyRate = 12;
  String? _selectedMinimumBooking = '1 Hour';
  String? _selectedAircraftOwnership = 'No';

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CfiInformationsScreen', 'initState', {
      'instructorRatings': _selectedInstructorRatings.toList(),
      'otherLicenses': _selectedOtherLicenses.toList(),
      'hourlyRate': _selectedHourlyRate,
      'minimumBooking': _selectedMinimumBooking,
      'aircraftOwnership': _selectedAircraftOwnership,
    });
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

        // Submit button
        PrimaryButton(
          label: 'Submit',
          onPressed: () {
            DebugLogger.log('CfiInformationsScreen', 'Submit pressed', {
              'instructorRatings': _selectedInstructorRatings.toList(),
              'otherLicenses': _selectedOtherLicenses.toList(),
              'hourlyRate': _selectedHourlyRate,
              'minimumBooking': _selectedMinimumBooking,
              'aircraftOwnership': _selectedAircraftOwnership,
            });
            // TODO: Submit form
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
