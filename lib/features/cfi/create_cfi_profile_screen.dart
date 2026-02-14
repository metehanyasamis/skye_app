import 'package:flutter/material.dart';
import 'package:skye_app/features/cfi/cfi_form_data_holder.dart';
import 'package:skye_app/features/cfi/cfi_informations_screen.dart';
import 'package:skye_app/shared/data/spoken_languages_data.dart';
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
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  // Selected values
  List<LanguageModel> _selectedLanguages = [];
  StateModel? _selectedStateModel;
  CityModel? _selectedCityModel;
  List<AirportModel> _selectedAirportModels = [];

  // Location state
  bool _hasLocation = false;

  bool _hasHydrated = false;

  @override
  void initState() {
    super.initState();
    DebugLogger.log('CreateCfiProfileScreen', 'initState()');
    _checkLocationStatus();
    _loadInitialData();
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
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleEnableLocation() {
    DebugLogger.log('CreateCfiProfileScreen', 'Enable Location pressed');
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
    DebugLogger.log('CreateCfiProfileScreen', 'Use current location');
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
      DebugLogger.log('CreateCfiProfileScreen', 'Address from GPS', {'address': address});
    }
  }

  Future<void> _openMapPicker() async {
    DebugLogger.log('CreateCfiProfileScreen', 'Open map picker');
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
      DebugLogger.log('CreateCfiProfileScreen', 'Address from map', {'address': address});
    }
  }

  void _handleAddressTap() async {
    DebugLogger.log('CreateCfiProfileScreen', 'Address onTap');
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
    DebugLogger.log('CreateCfiProfileScreen', 'Spoken languages onTap');
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

  bool _validateForm() {
    // TODO: Re-enable validation later
    // Validate required fields for step 1
    // if (_licenseNoController.text.isEmpty) return false;
    // if (_selectedBaseAirports.isEmpty) return false;
    // if (_selectedState == null) return false;
    // if (_selectedCity == null) return false;
    // if (_addressController.text.isEmpty) return false;
    return true; // Temporarily disabled for testing
  }

  void _hydrateFromFormData(Map<String, dynamic> data) {
    if (_hasHydrated) return;
    if (data.isEmpty) return;
    _hasHydrated = true;
    _licenseNoController.text = data['license_number']?.toString() ?? '';
    _addressController.text = data['address']?.toString() ?? '';
    _stateController.text = data['state']?.toString() ?? '';
    _cityController.text = data['city']?.toString() ?? '';
    final base = data['base_airport']?.toString();
    if (base != null && base.isNotEmpty) {
      _baseAirportsController.text = base;
      final ids = data['airport_ids'];
      if (ids is List && ids.isNotEmpty) {
        _selectedAirportModels = ids
            .map((e) => (e is num) ? (e as num).toInt() : int.tryParse(e.toString()))
            .whereType<int>()
            .map((id) => AirportModel(id: id, code: '', name: ''))
            .toList();
      }
    }
    final langs = data['spoken_languages'];
    if (langs is List && langs.isNotEmpty) {
      final raw = langs
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
      _selectedLanguages = raw
          .map((s) {
            final lower = s.toLowerCase();
            for (final l in spokenLanguagesList) {
              if (l.code.toLowerCase() == lower || l.name.toLowerCase() == lower) {
                return l;
              }
            }
            return null;
          })
          .whereType<LanguageModel>()
          .toList();
      _spokenLanguagesController.text =
          _selectedLanguages.map((l) => l.displayLabel).join(', ');
    }
    if (mounted) setState(() {});
  }

  void _handleNextPage() {
    if (!_validateForm()) {
      ToastOverlay.show(context, 'Please fill in all required fields');
      return;
    }

    DebugLogger.log('CreateCfiProfileScreen', 'Next Page pressed', {
      'spokenLanguages': _selectedLanguages.map((l) => l.code).toList(),
      'baseAirports': _selectedAirportModels.map((a) => a.displayLabel).toList(),
      'licenseNo': _licenseNoController.text,
      'state': _selectedStateModel?.name,
      'city': _selectedCityModel?.name,
      'address': _addressController.text,
    });

    // Collect form data
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
    CfiFormDataHolder.update(formData);

    // Navigate to information screen with form data
    Navigator.of(context).pushNamed(
      CfiInformationsScreen.routeName,
      arguments: formData,
    );
  }

  @override
  Widget build(BuildContext context) {
    DebugLogger.log('CreateCfiProfileScreen', 'build()');
    if (!_hasHydrated && CfiFormDataHolder.data.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _hydrateFromFormData(CfiFormDataHolder.data);
      });
    }

    return BaseFormScreen(
      title: 'Create CFI Profile',
      subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      currentStep: 1,
      totalSteps: 4,
      headerBackgroundColor: AppColors.navy800,
      headerImagePath: 'assets/images/cfi_headPic.png',
      children: [
        const SizedBox(height: 16),
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

        // State and City side by side - both required, from backend
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
                onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'state changed', {'value': v}),
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

        // Base airport(s) - multi-select from API
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
              onChanged: (v) => DebugLogger.log('CreateCfiProfileScreen', 'baseAirports changed', {'value': v}),
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

        // Next Page button
        PrimaryButton(
          label: 'Next Page',
          onPressed: _handleNextPage,
        ),

        // Location enable text - only show if location not selected and address empty
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
