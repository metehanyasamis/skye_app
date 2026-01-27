import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_summary_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/hourly_rate_selector.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class CfiExperiencesScreen extends StatefulWidget {
  const CfiExperiencesScreen({super.key});

  static const routeName = '/cfi/experiences';

  @override
  State<CfiExperiencesScreen> createState() => _CfiExperiencesScreenState();
}

class _CfiExperiencesScreenState extends State<CfiExperiencesScreen> {
  int _totalFlightHours = 12;
  int _totalGivenHours = 12;
  int _last12MonthsDualHours = 12;

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
    debugPrint('🧑‍✈️ [CfiExperiencesScreen] initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get form data from previous screens - must be in didChangeDependencies, not initState
    if (!_hasLoadedFormData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _formData = Map<String, dynamic>.from(args);
        _hasLoadedFormData = true;
      }
    }
  }

  Future<void> _showAircraftTypeDialog() async {
    // TODO: Load aircraft types from backend
    final allAircraftTypes = ['C172', 'PA-28', 'DA-40', 'C152', 'SR20', 'SR22']; // Placeholder
    
    // Filter out already selected aircraft types
    final selectedTypes = _aircraftExperiences.map((e) => e.type).toSet();
    final availableTypes = allAircraftTypes.where((type) => !selectedTypes.contains(type)).toList();
    
    if (availableTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All available aircraft types have been added'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final selectedType = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Select Aircraft Type',
          style: TextStyle(color: AppColors.labelBlack),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableTypes.length,
            itemBuilder: (context, index) {
              final type = availableTypes[index];
              return ListTile(
                title: Text(
                  type,
                  style: const TextStyle(color: AppColors.labelBlack),
                ),
                onTap: () {
                  Navigator.of(context).pop(type);
                },
              );
            },
          ),
        ),
      ),
    );

    if (selectedType != null) {
      setState(() {
        _aircraftExperiences.add(AircraftExperience(type: selectedType, hours: ''));
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
      children: [

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
            children: _aircraftExperiences.map((experience) {
              return _AircraftExperienceRow(
                aircraftType: experience.type,
                hours: experience.hours,
                onHoursChanged: (hours) {
                  DebugLogger.log('CfiExperiencesScreen', 'hours changed', {
                    'type': experience.type,
                    'hours': hours,
                  });
                  setState(() {
                    experience.hours = hours;
                  });
                },
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),

        // Add More button
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: TextButton(
            onPressed: () {
              DebugLogger.log('CfiExperiencesScreen', 'Add More pressed');
              _showAircraftTypeDialog();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  size: 24,
                  color: AppColors.selectedBlue,
                ),
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
            DebugLogger.log('CfiExperiencesScreen', 'Next Page pressed', {
              'totalFlightHours': _totalFlightHours,
              'totalGivenHours': _totalGivenHours,
              'last12MonthsDualHours': _last12MonthsDualHours,
              'aircraftExperiences': _aircraftExperiences.map((e) => {'type': e.type, 'hours': e.hours}).toList(),
            });
            
            // Collect all form data from previous screens
            final formData = <String, dynamic>{
              ..._formData,
              'total_flight_hours_exp': _totalFlightHours.toString(),
              'total_given_hours': _totalGivenHours.toString(),
              'last_12_months_dual_hours': _last12MonthsDualHours.toString(),
              'aircraft_experiences': _aircraftExperiences
                  .where((e) => e.type.isNotEmpty && e.hours.isNotEmpty)
                  .map((e) => {'type': e.type, 'hours': e.hours})
                  .toList(),
            };
            
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
    debugPrint('🛩️ [_AircraftExperienceRow] initState type="${widget.aircraftType}" hours="${widget.hours}"');
    _controller = TextEditingController(text: widget.hours);
  }

  @override
  void dispose() {
    debugPrint('🧹 [_AircraftExperienceRow] dispose type="${widget.aircraftType}"');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_AircraftExperienceRow] build type="${widget.aircraftType}"');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aircraft type label
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

          // Spacer to center the input field
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours input field - centered
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    onChanged: (v) {
                      debugPrint('⌨️ [_AircraftExperienceRow] type="${widget.aircraftType}" hours changed -> "$v"');
                      widget.onHoursChanged(v);
                    },
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
                        borderSide: BorderSide(
                          color: AppColors.labelBlack,
                          width: 1,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.labelBlack,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.selectedBlue,
                          width: 1.5,
                        ),
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

          // "hours" label - right aligned
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
