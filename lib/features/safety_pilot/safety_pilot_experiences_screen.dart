import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/widgets/aircraft_selector_sheet.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_summary_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class SafetyPilotExperiencesScreen extends StatefulWidget {
  const SafetyPilotExperiencesScreen({super.key});

  static const routeName = '/safety-pilot/experiences';

  @override
  State<SafetyPilotExperiencesScreen> createState() =>
      _SafetyPilotExperiencesScreenState();
}

class _SafetyPilotExperiencesScreenState
    extends State<SafetyPilotExperiencesScreen> {
  int _totalFlightHours = 300;

  final List<SafetyPilotAircraftExperience> _aircraftExperiences = [];

  Map<String, dynamic> _formData = {};
  bool _hasLoadedFormData = false;
  final _aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DebugLogger.log('SafetyPilotExperiencesScreen', 'initState');
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedFormData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _formData = Map<String, dynamic>.from(args);
        _hasLoadedFormData = true;
        _hydrateFromFormData();
      }
    }
  }

  void _hydrateFromFormData() {
    final notes = _formData['notes']?.toString();
    if (notes != null && notes.isNotEmpty) {
      _aboutMeController.text = notes;
    }
    final tfh = _formData['total_flight_hours_exp'] ?? _formData['total_flight_hours'];
    if (tfh != null) _totalFlightHours = int.tryParse(tfh.toString()) ?? 300;
    final exps = _formData['aircraft_experiences'];
    if (exps is List && exps.isNotEmpty) {
      _aircraftExperiences.clear();
      for (final e in exps) {
        if (e is Map) {
          final name = e['name']?.toString() ?? '';
          final code = e['type']?.toString() ?? e['code']?.toString() ?? '';
          final hours = e['hours']?.toString() ?? '';
          _aircraftExperiences.add(SafetyPilotAircraftExperience(
            aircraft: AircraftItem(name: name, code: code),
            hours: hours,
          ));
        }
      }
      if (mounted) setState(() {});
    }
  }

  Future<void> _addAircraftExperience() async {
    final exclude = _aircraftExperiences.map((e) => e.aircraft).toList();
    final picked = await showAircraftSelectorSheet(context, excludeAircraft: exclude);
    if (picked != null && mounted) {
      setState(() {
        _aircraftExperiences.add(SafetyPilotAircraftExperience(aircraft: picked, hours: ''));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('SafetyPilotExperiencesScreen', 'build()');

    return BaseFormScreen(
      title: 'Experiences',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 3,
      totalSteps: 4,
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),
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
              setState(() => _totalFlightHours = rate);
            },
          ),
        ),
        const SizedBox(height: 40),

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
              OutlinedButton.icon(
                onPressed: _addAircraftExperience,
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
            onChanged: (v) => DebugLogger.log('SafetyPilotExperiencesScreen', 'aboutMe changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 40),

        PrimaryButton(
          label: 'Next Page',
          onPressed: () {
            final formData = <String, dynamic>{
              ..._formData,
              'total_flight_hours_exp': _totalFlightHours.toString(),
              'aircraft_experiences': _aircraftExperiences
                  .map((e) => {'type': e.aircraft.code, 'name': e.aircraft.name, 'hours': e.hours})
                  .toList(),
              'notes': _aboutMeController.text.trim().isEmpty ? null : _aboutMeController.text.trim(),
            };
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SafetyPilotSummaryScreen(formData: formData),
              ),
            );
          },
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

class SafetyPilotAircraftExperience {
  final AircraftItem aircraft;
  String hours;

  SafetyPilotAircraftExperience({required this.aircraft, required this.hours});
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
