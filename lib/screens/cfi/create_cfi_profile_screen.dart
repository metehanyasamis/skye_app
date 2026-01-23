import 'package:flutter/material.dart';
import 'package:skye_app/theme/app_colors.dart';
import 'package:skye_app/utils/debug_logger.dart';
import 'package:skye_app/widgets/base_form_screen.dart';
import 'package:skye_app/widgets/form_field_with_icon.dart';
import 'package:skye_app/widgets/primary_button.dart';

class CreateCfiProfileScreen extends StatefulWidget {
  const CreateCfiProfileScreen({super.key});

  static const routeName = '/cfi/create-profile';

  @override
  State<CreateCfiProfileScreen> createState() => _CreateCfiProfileScreenState();
}

class _CreateCfiProfileScreenState extends State<CreateCfiProfileScreen> {
  final _spokenLanguagesController = TextEditingController();
  final _baseAirportsController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CreateCfiProfileScreen', 'initState()');
  }

  @override
  void dispose() {
    DebugLogger.log('CreateCfiProfileScreen', 'dispose()');
    _spokenLanguagesController.dispose();
    _baseAirportsController.dispose();
    _licenseNoController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CreateCfiProfileScreen', 'build()');

    return BaseFormScreen(
      title: 'Create CFI Profile',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 1,
      totalSteps: 4,
      children: [
        // Section header
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'More about you',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.labelBlack,
              height: 24 / 14,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Spoken languages
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FormFieldWithIcon(
            label: 'Spoken languages',
            icon: Icons.language,
            controller: _spokenLanguagesController,
            onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'spokenLanguages changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 24),

        // Base airport(s)
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FormFieldWithIcon(
            label: 'Base airport(s)',
            icon: Icons.flight_takeoff,
            controller: _baseAirportsController,
            onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'baseAirports changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 24),

        // License no
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FormFieldWithIcon(
            label: 'License no',
            icon: Icons.badge,
            controller: _licenseNoController,
            onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'licenseNo changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 24),

        // Country and City side by side
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Row(
            children: [
              Expanded(
                child: FormFieldWithIcon(
                  label: 'Country',
                  icon: Icons.public,
                  controller: _countryController,
                  onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'country changed', {'value': v}),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: FormFieldWithIcon(
                  label: 'City',
                  icon: Icons.location_city,
                  controller: _cityController,
                  onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'city changed', {'value': v}),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Address
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: FormFieldWithIcon(
            label: 'Address',
            icon: Icons.location_on,
            controller: _addressController,
            onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'address changed', {'value': v}),
          ),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: () {
            DebugLogger.log('CreateCfiProfileScreen', 'Next Page pressed', {
              'spokenLanguages': _spokenLanguagesController.text,
              'baseAirports': _baseAirportsController.text,
              'licenseNo': _licenseNoController.text,
              'country': _countryController.text,
              'city': _cityController.text,
              'address': _addressController.text,
            });
            // TODO: Navigate to next step
          },
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
                  DebugLogger.log('CreateCfiProfileScreen', 'Enable Location pressed');
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
