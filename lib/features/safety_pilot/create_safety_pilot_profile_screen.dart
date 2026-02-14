import 'package:flutter/material.dart';
import 'package:skye_app/features/safety_pilot/safety_pilot_informations_screen.dart';
import 'package:skye_app/shared/models/language_model.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/location_api_service.dart';
import 'package:skye_app/shared/services/location_service.dart';
import 'package:skye_app/shared/services/user_address_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/debug_logger.dart';
import 'package:skye_app/shared/utils/geocoding_helper.dart' as geocoding;
import 'package:skye_app/shared/widgets/address_selection_sheet.dart';
import 'package:skye_app/shared/widgets/base_form_screen.dart';
import 'package:skye_app/shared/widgets/form_field_with_icon.dart';
import 'package:skye_app/shared/widgets/location_permission_dialog.dart';
import 'package:skye_app/shared/widgets/location_picker_sheets.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/features/map/map_picker_screen.dart';
import 'package:skye_app/shared/widgets/spoken_language_picker_sheet.dart';

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
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  List<LanguageModel> _selectedLanguages = [];
  StateModel? _selectedStateModel;
  CityModel? _selectedCityModel;
  List<AirportModel> _selectedAirportModels = [];

  bool _hasLocation = false;

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'initState');
    _checkLocationStatus();
    _loadSavedAddress();
  }

  Future<void> _checkLocationStatus() async {
    final has = await LocationService.instance.hasPermission();
    if (mounted) {
      setState(() => _hasLocation = has);
    }
  }

  Future<void> _loadSavedAddress() async {
    final saved = await UserAddressService.instance.getStructuredAddress();
    if (saved == null || !mounted) return;
    final street = saved.street.trim();
    final city = saved.city.trim();
    final stateName = saved.state.trim();
    if (street.isEmpty && city.isEmpty && stateName.isEmpty) return;
    try {
      final states = await LocationApiService.instance.getStates();
      StateModel? stateModel;
      for (final s in states) {
        if (s.name.toLowerCase() == stateName.toLowerCase() || s.code.toLowerCase() == stateName.toLowerCase()) {
          stateModel = s;
          break;
        }
      }
      CityModel? cityModel;
      if (stateModel != null && city.isNotEmpty) {
        final cities = await LocationApiService.instance.getCitiesByState(stateModel.id);
        for (final c in cities) {
          if (c.name.toLowerCase() == city.toLowerCase()) {
            cityModel = c;
            break;
          }
        }
      }
      if (mounted) {
        setState(() {
          _addressController.text = UserAddressService.instance.address;
          _stateController.text = stateModel?.name ?? stateName;
          _cityController.text = cityModel?.name ?? city;
          _selectedStateModel = stateModel;
          _selectedCityModel = cityModel;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _addressController.text = UserAddressService.instance.address;
          _stateController.text = stateName;
          _cityController.text = city;
        });
      }
    }
  }

  @override
  void dispose() {
    _spokenLanguagesController.dispose();
    _baseAirportsController.dispose();
    _licenseNoController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleEnableLocation() {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Enable Location pressed');
    LocationPermissionDialog.show(
      context,
      onGoToSettings: () async {
        Navigator.of(context).pop();
        await LocationService.instance.openAppSettings();
        _checkLocationStatus();
      },
      onNoThanks: () {
        Navigator.of(context).pop();
        _openMapPicker();
      },
    );
  }

  Future<void> _useCurrentLocation() async {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Use current location');
    final pos = await LocationService.instance.getCurrentPosition();
    if (pos == null || !mounted) return;
    final p = await geocoding.reverseGeocodeToPlacemark(pos.latitude, pos.longitude);
    if (!mounted || p == null) return;
    final street = p.street ?? '';
    final city = p.locality ?? '';
    final state = p.administrativeArea ?? '';
    final zip = p.postalCode ?? '';
    final parts = [street, city, state, zip].where((s) => s.isNotEmpty);
    final address = parts.join(', ');
    if (address.isNotEmpty) {
      await UserAddressService.instance.setStructuredAddress(
        street: street,
        city: city,
        state: state,
        zip: zip,
      );
      if (mounted) {
        setState(() {
          _addressController.text = address;
          _hasLocation = true;
        });
        await _loadSavedAddress();
      }
      DebugLogger.log('CreateSafetyPilotProfileScreen', 'Address from GPS', {'address': address});
    }
  }

  Future<void> _openMapPicker() async {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Open map picker');
    final address = await Navigator.of(context).push<String?>(
      MaterialPageRoute<String?>(
        builder: (context) => MapPickerScreen(
          savedAddress: _addressController.text.trim().isNotEmpty ? _addressController.text : null,
        ),
      ),
    );
    if (!mounted) return;
    if (address != null) {
      await _loadSavedAddress();
      DebugLogger.log('CreateSafetyPilotProfileScreen', 'Address from map', {'address': address});
    }
  }

  void _handleAddressTap() async {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Address onTap');
    final hasPermission = await LocationService.instance.hasPermission();
    if (hasPermission) {
      await _openMapPicker();
    } else {
      final choice = await showAddressSelectionSheet(
        context,
        onUseMyLocation: () async {
          final granted = await LocationService.instance.ensurePermission();
          if (!mounted) return;
          if (granted) {
            await _useCurrentLocation();
          } else {
            _handleEnableLocation();
          }
        },
      );
      if (!mounted) return;
      if (choice == 'pick_on_map') {
        _openMapPicker();
      }
    }
  }

  void _handleLanguageSelection() async {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Spoken languages onTap');
    final picked = await showSpokenLanguagePickerSheet(
      context,
      initialSelected: _selectedLanguages,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedLanguages = picked;
        _spokenLanguagesController.text =
            _selectedLanguages.map((l) => l.displayLabel).join(', ');
      });
    }
  }

  void _handleStateSelection() async {
    final picked = await showStatePickerSheet(context, selected: _selectedStateModel);
    if (picked != null && mounted) {
      setState(() {
        _selectedStateModel = picked;
        _stateController.text = picked.name;
        _selectedCityModel = null;
        _cityController.clear();
      });
    }
  }

  void _handleCitySelection() async {
    if (_selectedStateModel == null) {
      ToastOverlay.show(context, 'Please select State first');
      return;
    }
    final picked = await showCityPickerSheet(
      context,
      stateId: _selectedStateModel!.id,
      selected: _selectedCityModel,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedCityModel = picked;
        _cityController.text = picked.name;
      });
    }
  }

  void _handleBaseAirportSelection() async {
    final picked = await showAirportPickerSheet(
      context,
      cityId: _selectedCityModel?.id,
      initialSelected: _selectedAirportModels,
      multiSelect: true,
    );
    if (picked != null && mounted) {
      setState(() {
        if (!_selectedAirportModels.any((a) => a.id == picked.id)) {
          _selectedAirportModels.add(picked);
          _baseAirportsController.text = _selectedAirportModels.map((a) => a.displayLabel).join(', ');
        }
      });
    }
  }

  void _handleNextPage() {
    DebugLogger.log('CreateSafetyPilotProfileScreen', 'Next Page pressed');
    final baseAirportDisplay = _selectedAirportModels.map((a) => a.displayLabel).join(', ');
    final formData = <String, dynamic>{
      'license_number': _licenseNoController.text,
      'base_airport': baseAirportDisplay,
      'state': _selectedStateModel?.name ?? _stateController.text.trim(),
      'city': _selectedCityModel?.name ?? _cityController.text.trim(),
      'state_id': _selectedStateModel?.id,
      'city_id': _selectedCityModel?.id,
      'airport_ids': _selectedAirportModels.map((a) => a.id).toList(),
      'address': _addressController.text,
      'spoken_languages': _selectedLanguages.map((l) => l.code).toList(),
      'spoken_languages_display': _selectedLanguages.map((l) => l.displayLabel).join(', '),
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
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),
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

        FormFieldWithIcon(
          label: 'Spoken languages',
          icon: Icons.language,
          controller: _spokenLanguagesController,
          fillColor: AppColors.white,
          readOnly: true,
          onTap: _handleLanguageSelection,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'spokenLanguages changed', {'value': v}),
        ),
        const SizedBox(height: 24),

        FormFieldWithIcon(
          label: 'License no',
          icon: Icons.badge,
          controller: _licenseNoController,
          fillColor: AppColors.white,
          isRequired: true,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'licenseNo changed', {'value': v}),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: FormFieldWithIcon(
                label: 'State',
                icon: Icons.public,
                controller: _stateController,
                fillColor: AppColors.white,
                isRequired: true,
                readOnly: true,
                onTap: _handleStateSelection,
                onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'state changed', {'value': v}),
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
                onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'city changed', {'value': v}),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        FormFieldWithIcon(
          label: 'Address',
          icon: Icons.location_on,
          controller: _addressController,
          fillColor: AppColors.white,
          isRequired: true,
          readOnly: true,
          onTap: _handleAddressTap,
          onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'address changed', {'value': v}),
        ),
        const SizedBox(height: 24),

        Stack(
          children: [
            FormFieldWithIcon(
              label: 'Base airport(s)',
              icon: Icons.flight_takeoff,
              controller: _baseAirportsController,
              fillColor: AppColors.white,
              isRequired: true,
              readOnly: true,
              onTap: _handleBaseAirportSelection,
              onChanged: (v) => DebugLogger.log('CreateSafetyPilotProfileScreen', 'baseAirports changed', {'value': v}),
            ),
            if (_selectedAirportModels.isNotEmpty)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20, color: AppColors.textSecondary),
                    onPressed: () {
                      setState(() {
                        _selectedAirportModels.clear();
                        _baseAirportsController.clear();
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 40),

        PrimaryButton(
          label: 'Next Page',
          onPressed: _handleNextPage,
        ),
        if (!_hasLocation && _addressController.text.trim().isEmpty) ...[
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
