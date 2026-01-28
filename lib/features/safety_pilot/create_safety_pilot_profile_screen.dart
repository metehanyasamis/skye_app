import 'package:flutter/material.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_informations_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class CreateSafetyPilotProfileScreen extends StatefulWidget {
  const CreateSafetyPilotProfileScreen({super.key});

  static const routeName = '/safety-pilot/create-profile';

  @override
  State<CreateSafetyPilotProfileScreen> createState() =>
      _CreateSafetyPilotProfileScreenState();
}

class _CreateSafetyPilotProfileScreenState
    extends State<CreateSafetyPilotProfileScreen> {
  final _spokenLanguagesController = TextEditingController();
  final _baseAirportsController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('🧑‍✈️ [CreateSafetyPilotProfileScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🧑‍✈️ [CreateSafetyPilotProfileScreen] dispose');
    _spokenLanguagesController.dispose();
    _baseAirportsController.dispose();
    _licenseNoController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleNextPage() {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Next Page pressed');
    final formData = <String, dynamic>{
      'spoken_languages': _spokenLanguagesController.text.trim(),
      'base_airport': _baseAirportsController.text.trim(),
      'license_number': _licenseNoController.text.trim(),
      'country': _countryController.text.trim(),
      'city': _cityController.text.trim(),
      'address': _addressController.text.trim(),
    };
    Navigator.of(context).pushNamed(
      SafetyPilotInformationsScreen.routeName,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'build');

    return BaseFormScreen(
      title: 'Create Safety Pilot Profile',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 1,
      totalSteps: 4,
      children: [

        // Section header
        const Text(
          'More about you',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.labelBlack,
            height: 24 / 14,
          ),
        ),

        const SizedBox(height: 16),

        // Spoken languages
        FormFieldWithIcon(
          label: 'Spoken languages',
          icon: Icons.language,
          controller: _spokenLanguagesController,
          fillColor: AppColors.white,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'spokenLanguages changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Base airport(s)
        FormFieldWithIcon(
          label: 'Base airport(s)',
          icon: Icons.flight_takeoff,
          controller: _baseAirportsController,
          fillColor: AppColors.white,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'baseAirports changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // License no
        FormFieldWithIcon(
          label: 'License no',
          icon: Icons.badge,
          controller: _licenseNoController,
          fillColor: AppColors.white,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'licenseNo changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Country and City side by side
        Row(
          children: [
            Expanded(
              child: FormFieldWithIcon(
                label: 'Country',
                icon: Icons.public,
                controller: _countryController,
                fillColor: AppColors.white,
                onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'country changed', {'value': v}),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FormFieldWithIcon(
                label: 'City',
                icon: Icons.location_city,
                controller: _cityController,
                fillColor: AppColors.white,
                onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'city changed', {'value': v}),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Address
        FormFieldWithIcon(
          label: 'Address',
          icon: Icons.location_on,
          controller: _addressController,
          fillColor: AppColors.white,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'address changed', {'value': v}),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: _handleNextPage,
        ),

        const SizedBox(height: 24),

        // Location enable text
        Center(
          child: Column(
            children: [
              const Text(
                'Turn your location on to autofill your address',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.labelBlack60,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () {
                  DebugLogger.log('CreateSafetyPilotProfileScreen', 'Enable Location pressed');
                  // TODO: Enable location
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Enable Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.labelDarkSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
