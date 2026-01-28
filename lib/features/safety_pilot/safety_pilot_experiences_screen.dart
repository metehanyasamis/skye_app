import 'package:flutter/material.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_summary_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
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
  int _totalFlightHours = 12;

  final List<AircraftExperience> _aircraftExperiences = [
    AircraftExperience(type: 'C172', hours: ''),
    AircraftExperience(type: 'PA-28', hours: ''),
    AircraftExperience(type: 'DA-40', hours: ''),
  ];

  Map<String, dynamic> _formData = {};
  bool _hasLoadedFormData = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🧑‍✈️ [SafetyPilotExperiencesScreen] initState');
  }

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

  @override
  void dispose() {
    debugPrint('🧑‍✈️ [SafetyPilotExperiencesScreen] dispose');
    super.dispose();
  }

  Future<void> _showAircraftTypeDialog() async {
    final allAircraftTypes = ['C172', 'PA-28', 'DA-40', 'C152', 'SR20', 'SR22'];
    final selectedTypes = _aircraftExperiences.map((e) => e.type).toSet();
    final availableTypes = allAircraftTypes.where((t) => !selectedTypes.contains(t)).toList();
    if (availableTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All available aircraft types have been added'), backgroundColor: Colors.orange),
      );
      return;
    }
    final selectedType = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Aircraft Type', style: TextStyle(color: AppColors.labelBlack)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableTypes.length,
            itemBuilder: (ctx, i) {
              final t = availableTypes[i];
              return ListTile(
                title: Text(t, style: const TextStyle(color: AppColors.labelBlack)),
                onTap: () => Navigator.of(ctx).pop(t),
              );
            },
          ),
        ),
      ),
    );
    if (selectedType != null) {
      setState(() => _aircraftExperiences.add(AircraftExperience(type: selectedType, hours: '')));
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
      children: [

        // Total flight hours section (CFI ile aynı)
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
            onRateSelected: (rate) {
              DebugLogger.log('SafetyPilotExperiencesScreen', 'totalFlightHours selected', {'rate': rate});
              setState(() => _totalFlightHours = rate);
            },
          ),
        ),

        const SizedBox(height: 40),

        // Aircraft type experience section (CFI ile aynı)
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
            children: _aircraftExperiences.map((e) {
              return _AircraftExperienceRow(
                aircraftType: e.type,
                hours: e.hours,
                onHoursChanged: (h) {
                  DebugLogger.log('SafetyPilotExperiencesScreen', 'hours changed', {'type': e.type, 'hours': h});
                  setState(() => e.hours = h);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: TextButton(
            onPressed: _showAircraftTypeDialog,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, size: 24, color: AppColors.selectedBlue),
                SizedBox(width: 4),
                Text(
                  'Add More',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.selectedBlue,
                    height: 24 / 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: () {
            DebugLogger.log('SafetyPilotExperiencesScreen', 'Next Page pressed');
            final formData = <String, dynamic>{
              ..._formData,
              'total_flight_hours': _totalFlightHours.toString(),
              'aircraft_experiences': _aircraftExperiences
                  .where((e) => e.type.isNotEmpty && e.hours.isNotEmpty)
                  .map((e) => {'type': e.type, 'hours': e.hours})
                  .toList(),
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

class AircraftExperience {
  String type;
  String hours;

  AircraftExperience({required this.type, required this.hours});
}


class _AircraftExperienceRow extends StatefulWidget {
  const _AircraftExperienceRow({
    required this.aircraftType,
    required this.hours,
    required this.onHoursChanged,
  });

  final String aircraftType;
  final String hours;
  final ValueChanged<String> onHoursChanged;

  @override
  State<_AircraftExperienceRow> createState() => _AircraftExperienceRowState();
}

class _AircraftExperienceRowState extends State<_AircraftExperienceRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🧾 [_AircraftExperienceRow] initState type="${widget.aircraftType}", hours="${widget.hours}"');
    _controller = TextEditingController(text: widget.hours);
  }

  @override
  void didUpdateWidget(covariant _AircraftExperienceRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hours != widget.hours && _controller.text != widget.hours) {
      debugPrint(
          '🔄 [_AircraftExperienceRow] didUpdateWidget type="${widget.aircraftType}" oldHours="${oldWidget.hours}" newHours="${widget.hours}"');
      _controller.text = widget.hours;
    }
  }

  @override
  void dispose() {
    debugPrint('🧾 [_AircraftExperienceRow] dispose type="${widget.aircraftType}"');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              widget.aircraftType,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.labelBlack,
                height: 24 / 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    onChanged: (v) => widget.onHoursChanged(v),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              'hours',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.labelDarkSecondary.withValues(alpha: 0.5),
                height: 24 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
