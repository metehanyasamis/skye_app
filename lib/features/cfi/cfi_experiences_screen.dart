import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skye_app/features/cfi/cfi_form_data_holder.dart';
import 'package:skye_app/features/cfi/cfi_summary_screen.dart';
import 'package:skye_app/features/cfi/widgets/aircraft_selector_sheet.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class CfiExperiencesScreen extends StatefulWidget {
  const CfiExperiencesScreen({super.key});

  static const routeName = '/cfi/experiences';

  @override
  State<CfiExperiencesScreen> createState() => _CfiExperiencesScreenState();
}

class _CfiExperiencesScreenState extends State<CfiExperiencesScreen> {
  int _totalFlightHours = 300;
  int _totalGivenHours = 300;
  int _last12MonthsDualHours = 300;

  final List<AircraftExperience> _aircraftExperiences = [];

  Map<String, dynamic> _formData = {};
  bool _hasLoadedFormData = false;
  final _aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('🧑‍✈️ [CfiExperiencesScreen] initState');
  }

  void _saveToHolder() {
    CfiFormDataHolder.update({
      ..._formData,
      'total_flight_hours_exp': _totalFlightHours.toString(),
      'total_given_hours': _totalGivenHours.toString(),
      'last_12_months_dual_hours': _last12MonthsDualHours.toString(),
      'aircraft_experiences': _aircraftExperiences
          .map((e) => {'type': e.aircraft.code, 'name': e.aircraft.name, 'hours': e.hours})
          .toList(),
      'notes': _aboutMeController.text.trim().isEmpty ? null : _aboutMeController.text.trim(),
    });
  }

  @override
  void dispose() {
    _saveToHolder(); // Persist when leaving (back press)
    _aboutMeController.dispose();
    super.dispose();
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
    final notes = _formData['notes']?.toString();
    if (notes != null && notes.isNotEmpty) {
      _aboutMeController.text = notes;
    }
    final tfh = _formData['total_flight_hours_exp'];
    if (tfh != null) _totalFlightHours = int.tryParse(tfh.toString()) ?? 300;
    final tgh = _formData['total_given_hours'];
    if (tgh != null) _totalGivenHours = int.tryParse(tgh.toString()) ?? 300;
    final l12 = _formData['last_12_months_dual_hours'];
    if (l12 != null) _last12MonthsDualHours = int.tryParse(l12.toString()) ?? 300;
    final exps = CfiFormDataHolder.getAircraftExperiences(_formData);
    if (exps.isNotEmpty) {
      _aircraftExperiences
        ..clear()
        ..addAll(exps.map((e) {
          final name = e['name']?.toString() ?? '';
          final code = e['type']?.toString() ?? e['code']?.toString() ?? '';
          final hours = e['hours']?.toString() ?? '';
          return AircraftExperience(
            aircraft: AircraftItem(name: name, code: code),
            hours: hours,
          );
        }));
    }
    if (mounted) setState(() {});
  }

  Future<void> _addAircraftExperience() async {
    final exclude = _aircraftExperiences.map((e) => e.aircraft).toList();
    final picked = await showAircraftSelectorSheet(context, excludeAircraft: exclude);
    if (picked != null && mounted) {
      setState(() {
        _aircraftExperiences.add(AircraftExperience(aircraft: picked, hours: ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CfiExperiencesScreen', 'build()');

    return BaseFormScreen(
      title: 'Experiences',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 3,
      totalSteps: 4,
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),

        // Total flight hours section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Total flight hours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: HourlyRateSelector(
            selectedRate: _totalFlightHours,
            showSlider: true,
            onRateSelected: (rate) {
              DebugLogger.log('CfiExperiencesScreen', 'totalFlightHours changed', {'rate': rate});
              setState(() {
                _totalFlightHours = rate;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Total given hours section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Total given hours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: HourlyRateSelector(
            selectedRate: _totalGivenHours,
            showSlider: true,
            onRateSelected: (rate) {
              DebugLogger.log('CfiExperiencesScreen', 'totalGivenHours changed', {'rate': rate});
              setState(() {
                _totalGivenHours = rate;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Last 12 months dual hours section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Last 12 months dual hours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: HourlyRateSelector(
            selectedRate: _last12MonthsDualHours,
            showSlider: true,
            onRateSelected: (rate) {
              DebugLogger.log('CfiExperiencesScreen', 'last12MonthsDualHours changed', {'rate': rate});
              setState(() {
                _last12MonthsDualHours = rate;
              });
            },
          ),
        ),

        const SizedBox(height: 40),

        // Aircraft type experience section
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'Aircraft type experience',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Aircraft experience rows - informations ile aynı yapı (ad, kod, saat alanı, hours, remove)
              ..._aircraftExperiences.map((experience) => Padding(
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
                              experience.aircraft.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.labelBlack,
                              ),
                            ),
                            Text(
                              experience.aircraft.code,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 48,
                                  child: _HoursInputField(
                                    initialValue: experience.hours,
                                    onChanged: (v) => setState(() => experience.hours = v),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'hours',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.labelDarkSecondary.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => _aircraftExperiences.remove(experience));
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
              // Add more - informations ile aynı yapı
              OutlinedButton.icon(
                onPressed: () {
                  DebugLogger.log('CfiExperiencesScreen', 'Add More pressed');
                  _addAircraftExperience();
                },
                icon: const Icon(Icons.add, size: 20, color: AppColors.selectedBlue),
                label: const Text(
                  'Add more',
                  style: TextStyle(
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

        const SizedBox(height: 40),

        // About me (Notes taşındı - experience sayfasında en altta)
        const Padding(
          padding: EdgeInsets.only(left: 2),
          child: Text(
            'About me',
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
          child: FormFieldWithIcon(
            label: 'Tell us about yourself',
            icon: Icons.person_outline,
            controller: _aboutMeController,
            fillColor: AppColors.white,
            minLines: 3,
            maxLines: 5,
            onChanged: (v) => DebugLogger.log('CfiExperiencesScreen', 'aboutMe changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: () {
            DebugLogger.log('CfiExperiencesScreen', 'Next Page pressed', {
              'totalFlightHours': _totalFlightHours,
              'totalGivenHours': _totalGivenHours,
              'last12MonthsDualHours': _last12MonthsDualHours,
              'aircraftExperiences': _aircraftExperiences.map((e) => {'type': e.aircraft.code, 'name': e.aircraft.name, 'hours': e.hours}).toList(),
              'aboutMe': _aboutMeController.text,
            });
            
            final formData = <String, dynamic>{
              ..._formData,
              'total_flight_hours_exp': _totalFlightHours.toString(),
              'total_given_hours': _totalGivenHours.toString(),
              'last_12_months_dual_hours': _last12MonthsDualHours.toString(),
              'aircraft_experiences': _aircraftExperiences
                  .map((e) => {'type': e.aircraft.code, 'name': e.aircraft.name, 'hours': e.hours})
                  .toList(),
              'notes': _aboutMeController.text.trim().isEmpty ? null : _aboutMeController.text.trim(),
            };
            CfiFormDataHolder.update(formData);

            // Navigate to summary screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CfiSummaryScreen(formData: formData),
              ),
            );
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

class AircraftExperience {
  final AircraftItem aircraft;
  String hours;

  AircraftExperience({required this.aircraft, required this.hours});
}

class _HoursInputField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _HoursInputField({
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_HoursInputField> createState() => _HoursInputFieldState();
}

class _HoursInputFieldState extends State<_HoursInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_HoursInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.collapsed(offset: widget.initialValue.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textAlign: TextAlign.center,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.labelBlack,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.labelBlack, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.labelBlack, width: 1),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.selectedBlue, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        isDense: true,
      ),
    );
  }
}
