import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_experiences_screen.dart';
import 'package:skye_app/features/cfi/cfi_form_data_holder.dart';
import 'package:skye_app/features/cfi/widgets/aircraft_selector_sheet.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/booking_chips.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';
import 'package:skye_app/shared/widgets/rating_chips.dart';

class CfiInformationsScreen extends StatefulWidget {
  const CfiInformationsScreen({super.key});

  static const routeName = '/cfi/informations';

  @override
  State<CfiInformationsScreen> createState() => _CfiInformationsScreenState();
}

class _CfiInformationsScreenState extends State<CfiInformationsScreen> {
  final Set<String> _selectedInstructorRatings = {};
  final Set<String> _selectedOtherLicenses = {};
  int _selectedHourlyRate = 250;
  String? _selectedMinimumBooking;
  String? _selectedAircraftOwnership;
  final List<AircraftItem> _selectedAircrafts = [];

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
    if (!_hasLoadedFormData) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _formData = CfiFormDataHolder.mergeWithArgs(args);
      _hasLoadedFormData = true;
      _hydrateFromFormData();
    }
  }

  void _hydrateFromFormData() {
    final ir = _formData['instructor_ratings'];
    if (ir is List && ir.isNotEmpty) {
      _selectedInstructorRatings.addAll(ir.map((e) => e.toString()));
    }
    final ol = _formData['other_licenses'];
    if (ol is List && ol.isNotEmpty) {
      _selectedOtherLicenses.addAll(ol.map((e) => e.toString()));
    }
    final hr = _formData['hourly_rate'];
    if (hr != null) {
      _selectedHourlyRate = int.tryParse(hr.toString()) ?? 250;
    }
    _selectedMinimumBooking = _formData['minimum_booking']?.toString();
    _selectedAircraftOwnership = _formData['aircraft_ownership']?.toString();
    _selectedAircrafts
      ..clear()
      ..addAll(CfiFormDataHolder.getSelectedAircrafts(_formData));
  }

  void _saveToHolder() {
    CfiFormDataHolder.update({
      ..._formData,
      'instructor_ratings': _selectedInstructorRatings.toList(),
      'other_licenses': _selectedOtherLicenses.toList(),
      'hourly_rate': _selectedHourlyRate.toString(),
      'minimum_booking': _selectedMinimumBooking ?? '',
      'aircraft_ownership': _selectedAircraftOwnership ?? '',
      'selected_aircrafts': _selectedAircrafts
          .map((a) => {'name': a.name, 'code': a.code})
          .toList(),
    });
  }

  @override
  void dispose() {
    _saveToHolder(); // Persist when leaving (back press)
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
      ToastOverlay.show(context, 'Please fill in all required fields');
      return;
    }

    DebugLogger.log('CfiInformationsScreen', 'Next Page pressed', {
      'instructorRatings': _selectedInstructorRatings.toList(),
      'otherLicenses': _selectedOtherLicenses.toList(),
      'hourlyRate': _selectedHourlyRate,
      'minimumBooking': _selectedMinimumBooking,
      'aircraftOwnership': _selectedAircraftOwnership,
      'selectedAircrafts': _selectedAircrafts.map((a) => '${a.name} (${a.code})').toList(),
    });

    final previousData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final formData = <String, dynamic>{
      ...previousData,
      'instructor_ratings': _selectedInstructorRatings.toList(),
      'other_licenses': _selectedOtherLicenses.toList(),
      'hourly_rate': _selectedHourlyRate.toString(),
      'minimum_booking': _selectedMinimumBooking ?? '',
      'aircraft_ownership': _selectedAircraftOwnership ?? '',
      'selected_aircrafts': _selectedAircrafts
          .map((a) => {'name': a.name, 'code': a.code})
          .toList(),
    };
    CfiFormDataHolder.update(formData);

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
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),

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
            options: const ['CFI', 'CFII', 'MEI'],
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
            options: const ['PPL', 'CPL', 'IR', 'ATP'],
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

        // Minimum booking section - centered
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
          child: Center(
            child: BookingChips(
              options: const ['1 Hour', '3 Hours', '1 Day', 'Always'],
              selected: _selectedMinimumBooking,
              centered: true,
              onSelectionChanged: (selected) {
                DebugLogger.log('CfiInformationsScreen', 'minimumBooking changed', {'selected': selected});
                setState(() {
                  _selectedMinimumBooking = selected;
                });
              },
            ),
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
                if (selected == 'No') {
                  _selectedAircrafts.clear();
                }
              });
            },
          ),
        ),
        if (_selectedAircraftOwnership == 'Yes') ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selected aircraft list
                if (_selectedAircrafts.isNotEmpty) ...[
                  ..._selectedAircrafts.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.labelBlack,
                                  ),
                                ),
                                Text(
                                  a.code,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => _selectedAircrafts.remove(a));
                            },
                            icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 8),
                ],
                // Add / Select button
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showAircraftSelectorSheet(
                      context,
                      excludeAircraft: _selectedAircrafts,
                    );
                    if (picked != null && mounted) {
                      setState(() => _selectedAircrafts.add(picked));
                    }
                  },
                  icon: const Icon(Icons.add, size: 20, color: AppColors.selectedBlue),
                  label: Text(
                    _selectedAircrafts.isEmpty ? 'Select Aircraft' : 'Add more',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.selectedBlue,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.selectedBlue,
                    side: const BorderSide(color: AppColors.selectedBlue),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

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
