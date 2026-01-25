import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    debugPrint('🧑‍✈️ [CfiExperiencesScreen] initState');
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
        Padding(
          padding: const EdgeInsets.only(left: 2),
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
        Padding(
          padding: const EdgeInsets.only(left: 2),
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
        Padding(
          padding: const EdgeInsets.only(left: 2),
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
              setState(() {
                _aircraftExperiences.add(AircraftExperience(type: '', hours: ''));
              });
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
            // TODO: Navigate to next step
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

          // Hours input field
          Expanded(
            child: Container(
              height: 27,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.labelBlack,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (v) {
                  debugPrint('⌨️ [_AircraftExperienceRow] type="${widget.aircraftType}" hours changed -> "$v"');
                  widget.onHoursChanged(v);
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.labelBlack,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // "hours" label
          Text(
            'hours',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.labelDarkSecondary.withValues(alpha: 0.5),
              height: 24 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
