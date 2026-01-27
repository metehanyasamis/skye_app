import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_informations_screen.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/location_permission_dialog.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';

class CreateCfiProfileScreen extends StatefulWidget {
  const CreateCfiProfileScreen({super.key});

  static const routeName = '/cfi/create-profile';

  @override
  State<CreateCfiProfileScreen> createState() => _CreateCfiProfileScreenState();
}

class _CreateCfiProfileScreenState extends State<CreateCfiProfileScreen> {
  // Controllers
  final _spokenLanguagesController = TextEditingController();
  final _baseAirportsController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected values
  List<String> _selectedLanguages = [];
  String? _selectedCountry;
  String? _selectedCity;
  List<String> _selectedBaseAirports = [];

  // Location state
  bool _hasLocation = false; // TODO: Get from location service
  String? _selectedAddress; // TODO: Get from location service

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CreateCfiProfileScreen', 'initState()');
    _checkLocationStatus();
    _loadInitialData();
  }

  void _checkLocationStatus() {
    // TODO: Check if user has selected location
    // For now, set to false
    setState(() {
      _hasLocation = false;
    });
  }

  Future<void> _loadInitialData() async {
    // TODO: Load languages, countries, cities, airports from backend
    // For now, placeholder
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
    _notesController.dispose();
    super.dispose();
  }

  void _handleEnableLocation() {
    DebugLogger.log('CreateCfiProfileScreen', 'Enable Location pressed');
    LocationPermissionDialog.show(
      context,
      onGoToSettings: () {
        Navigator.of(context).pop();
        // TODO: Open location settings
        // After location is enabled, update _hasLocation and _selectedAddress
        _checkLocationStatus();
      },
      onNoThanks: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _handleAddressTap() {
    if (_hasLocation && _selectedAddress != null) {
      // Location already selected, auto-fill
      _addressController.text = _selectedAddress!;
      DebugLogger.log('CreateCfiProfileScreen', 'Address auto-filled from location');
    } else {
      // No location, show Enable Location dialog
      _handleEnableLocation();
    }
  }

  void _handleLanguageSelection() {
    // TODO: Show multi-select dialog for languages from backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Languages'),
        content: const Text('Language selection dialog - TODO: Connect to backend'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update _selectedLanguages from backend data
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleCountrySelection() {
    // TODO: Show dropdown/dialog for countries from backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Country'),
        content: const Text('Country selection dialog - TODO: Connect to backend'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update _selectedCountry from backend data
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleCitySelection() {
    // TODO: Show dropdown/dialog for cities from backend (filtered by country)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select City'),
        content: const Text('City selection dialog - TODO: Connect to backend'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update _selectedCity from backend data
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleBaseAirportSelection() {
    // TODO: Show multi-select dialog for airports from backend
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Base Airport(s)'),
        content: const Text('Airport selection dialog - TODO: Connect to backend'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update _selectedBaseAirports from backend data
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _validateForm() {
    // TODO: Re-enable validation later
    // Validate required fields for step 1
    // if (_licenseNoController.text.isEmpty) return false;
    // if (_selectedBaseAirports.isEmpty) return false;
    // if (_selectedCountry == null) return false;
    // if (_selectedCity == null) return false;
    // if (_addressController.text.isEmpty) return false;
    return true; // Temporarily disabled for testing
  }

  void _handleNextPage() {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    DebugLogger.log('CreateCfiProfileScreen', 'Next Page pressed', {
      'spokenLanguages': _selectedLanguages,
      'baseAirports': _selectedBaseAirports,
      'licenseNo': _licenseNoController.text,
      'country': _selectedCountry,
      'city': _selectedCity,
      'address': _addressController.text,
      'notes': _notesController.text,
    });

    // Collect form data
    final formData = <String, dynamic>{
      'license_number': _licenseNoController.text,
      'base_airport': _selectedBaseAirports.isNotEmpty ? _selectedBaseAirports.join(', ') : '',
      'country': _selectedCountry ?? '',
      'city': _selectedCity ?? '',
      'address': _addressController.text,
      'notes': _notesController.text,
      'spoken_languages': _selectedLanguages,
      // NOTE: pilot_type and package_id will be set in summary screen
      // Backend rejects 'instructor' and package_id: 1, so we don't set defaults here
    };

    // Navigate to information screen with form data
    Navigator.of(context).pushNamed(
      CfiInformationsScreen.routeName,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CreateCfiProfileScreen', 'build()');

    return BaseFormScreen(
      title: 'Create CFI Profile',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 1,
      totalSteps: 4,
      // Removed bottomNavigationBar
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

        // Spoken languages - multi-select
        FormFieldWithIcon(
          label: 'Spoken languages',
          icon: Icons.language,
          controller: _spokenLanguagesController,
          fillColor: AppColors.white,
          readOnly: true,
          onTap: _handleLanguageSelection,
          onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'spokenLanguages changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Base airport(s) - multi-select from backend
        FormFieldWithIcon(
          label: 'Base airport(s)',
          icon: Icons.flight_takeoff,
          controller: _baseAirportsController,
          fillColor: AppColors.white,
          isRequired: true,
          readOnly: true,
          onTap: _handleBaseAirportSelection,
          onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'baseAirports changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // License no - required
        FormFieldWithIcon(
          label: 'License no',
          icon: Icons.badge,
          controller: _licenseNoController,
          fillColor: AppColors.white,
          isRequired: true,
          onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'licenseNo changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Country and City side by side - both required, from backend
        Row(
          children: [
            Expanded(
              child: FormFieldWithIcon(
                label: 'Country',
                icon: Icons.public,
                controller: _countryController,
                fillColor: AppColors.white,
                isRequired: true,
                readOnly: true,
                onTap: _handleCountrySelection,
                onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'country changed', {'value': v}),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FormFieldWithIcon(
                label: 'City',
                icon: Icons.location_city,
                controller: _cityController,
                fillColor: AppColors.white,
                isRequired: true,
                readOnly: true,
                onTap: _handleCitySelection,
                onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'city changed', {'value': v}),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Address - required, auto-fill if location selected
        FormFieldWithIcon(
          label: 'Address',
          icon: Icons.location_on,
          controller: _addressController,
          fillColor: AppColors.white,
          isRequired: true,
          readOnly: true,
          onTap: _handleAddressTap,
          onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'address changed', {'value': v}),
        ),

        const SizedBox(height: 24),

        // Notes - optional
        FormFieldWithIcon(
          label: 'Notes',
          icon: Icons.note,
          controller: _notesController,
          fillColor: AppColors.white,
          minLines: 3,
          maxLines: 5,
          onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'notes changed', {'value': v}),
        ),

        const SizedBox(height: 40),

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: _handleNextPage,
        ),

        // Location enable text - only show if location not selected
        if (!_hasLocation) ...[
          const SizedBox(height: 24),
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
                  onPressed: _handleEnableLocation,
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
        ],

        const SizedBox(height: 40),
      ],
    );
  }
}
