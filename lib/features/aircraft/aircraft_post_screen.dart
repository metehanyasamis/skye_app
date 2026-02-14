import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/utils/system_ui_helper.dart';
import 'package:skye_app/shared/widgets/booking_chips.dart';
import 'package:skye_app/shared/widgets/location_picker_sheets.dart';
import 'package:skye_app/shared/widgets/primary_button.dart';
import 'package:skye_app/shared/widgets/toast_overlay.dart';


class AircraftPostScreen extends StatefulWidget {
  const AircraftPostScreen({super.key});

  static const routeName = '/aircraft/post';

  @override
  State<AircraftPostScreen> createState() => _AircraftPostScreenState();
}

class _AircraftPostScreenState extends State<AircraftPostScreen> {
  final _aircraftBrandController = TextEditingController();
  final _baseAirportsController = TextEditingController();
  final _aircraftNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _seatsController = TextEditingController();
  final _wetPriceController = TextEditingController();
  final _dryPriceController = TextEditingController();

  String _listingType = 'rental'; // 'rental' | 'sale'
  StateModel? _selectedStateModel;
  CityModel? _selectedCityModel;
  List<AirportModel> _selectedAirportModels = [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📝 [AircraftPostScreen] initState');
  }

  @override
  void dispose() {
    debugPrint('🧹 [AircraftPostScreen] dispose - controllers disposing');

    _aircraftBrandController.dispose();
    _baseAirportsController.dispose();
    _aircraftNameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _seatsController.dispose();
    _wetPriceController.dispose();
    _dryPriceController.dispose();

    super.dispose();
  }

  void _onChooseImagePressed() {
    debugPrint('📸 [AircraftPostScreen] Choose image pressed');
    // TODO: Open image picker
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Future<void> _onAdvertisePressed() async {
    if (_submitting) return;

    final title = _aircraftNameController.text.trim();
    final model = _aircraftBrandController.text.trim();
    if (title.isEmpty || model.isEmpty) {
      ToastOverlay.show(context, 'Please fill Aircraft name and Aircraft brand');
      return;
    }

    setState(() => _submitting = true);
    FocusScope.of(context).unfocus();

    final stateName = _selectedStateModel?.name ?? _countryController.text.trim();
    final cityName = _selectedCityModel?.name ?? _cityController.text.trim();
    final location = [cityName, stateName].where((s) => s.isNotEmpty).join(', ');
    final seatCount = int.tryParse(_seatsController.text.trim());
    final wetPrice = double.tryParse(_wetPriceController.text.trim().replaceAll(',', '.'));
    final dryPrice = double.tryParse(_dryPriceController.text.trim().replaceAll(',', '.'));

    final baseAirportStr = _selectedAirportModels.map((a) => a.displayLabel).join(', ');
    final body = <String, dynamic>{
      'title': title,
      'model': model,
      'base_airport': baseAirportStr.isNotEmpty ? baseAirportStr : _baseAirportsController.text.trim(),
      'location': location.isNotEmpty ? location : _addressController.text.trim(),
      'address': _addressController.text.trim(),
      'listing_type': _listingType,
      'availability_status': 'available',
      'seat_count': seatCount ?? 0,
      'wet_price': wetPrice ?? 0,
      'dry_price': dryPrice ?? 0,
      'price': (wetPrice ?? dryPrice) ?? 0,
    };

    try {
      await AircraftApiService.instance.createAircraftListing(body);
      if (!mounted) return;
      ToastOverlay.show(context, 'Aircraft listing created', isError: false);
      Navigator.of(context).pop();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      final msg = e.response?.data?.toString() ?? e.message ?? 'Request failed';
      ToastOverlay.show(context, 'Failed to create listing: $msg');
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ToastOverlay.show(context, 'Failed to create listing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [AircraftPostScreen] build()');

    SystemUIHelper.setLightStatusBar();
    debugPrint('✅ [AircraftPostScreen] SystemChrome.setSystemUIOverlayStyle applied');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.cfiBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cfiBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.labelBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _dismissKeyboard,
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
            // Drag handle
            Builder(
              builder: (context) {
                debugPrint('🟦 [AircraftPostScreen] Drag handle built');
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 135,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF161455),
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Main image section
            Builder(
              builder: (context) {
                debugPrint('🖼️ [AircraftPostScreen] Main image section built');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    height: 153,
                    decoration: BoxDecoration(
                      color: AppColors.navy900.withValues(alpha: 0.73),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            Icons.flight,
                            size: 80,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'CHOOSE AN IMAGE',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                onPressed: _onChooseImagePressed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Thumbnail images
            Builder(
              builder: (context) {
                debugPrint('🖼️ [AircraftPostScreen] Thumbnails row built');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 99,
                          decoration: BoxDecoration(
                            color: AppColors.cardLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 99,
                          decoration: BoxDecoration(
                            color: AppColors.cardLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // "For the best shot" section
            Builder(
              builder: (context) {
                debugPrint('💡 [AircraftPostScreen] Tips section built');
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cfiBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.labelBlack,
                        height: 23 / 15,
                      ),
                      children: [
                        TextSpan(
                          text: 'For the best shot:\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' – Capture the aircraft from its most striking angle.\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.labelDarkSecondary,
                          ),
                        ),
                        TextSpan(
                          text: ' – Keep the background simple and clean.\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.labelDarkSecondary,
                          ),
                        ),
                        TextSpan(
                          text:
                          ' – Make sure there are no people in the frame, let the aircraft be the star.\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.labelDarkSecondary,
                          ),
                        ),
                        TextSpan(
                          text:
                          ' – If available, shooting in a hangar or enclosed space can make the image look even more refined.',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: AppColors.labelDarkSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // "About your aircraft" section
            Builder(
              builder: (context) {
                debugPrint('🧾 [AircraftPostScreen] About your aircraft section built');
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cfiBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About your aircraft:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.labelBlack,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _FormFieldWithIcon(
                        label: 'Aircraft brand',
                        controller: _aircraftBrandController,
                        icon: Icons.flight,
                      ),
                      const SizedBox(height: 24),

                      _LocationPickerField(
                        label: 'Base airport(s)',
                        icon: Icons.flight_takeoff,
                        value: _selectedAirportModels.map((a) => a.displayLabel).join(', '),
                        onTap: () async {
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
                              }
                            });
                          }
                        },
                        onClear: _selectedAirportModels.isNotEmpty
                            ? () => setState(() => _selectedAirportModels.clear())
                            : null,
                      ),
                      const SizedBox(height: 24),

                      _FormField(
                        label: 'Aircraft name',
                        controller: _aircraftNameController,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _LocationPickerField(
                              label: 'State',
                              icon: Icons.public,
                              value: _selectedStateModel?.name ?? _countryController.text,
                              onTap: () async {
                                final picked = await showStatePickerSheet(
                                  context,
                                  selected: _selectedStateModel,
                                );
                                if (picked != null && mounted) {
                                  setState(() {
                                    _selectedStateModel = picked;
                                    _countryController.text = picked.name;
                                    _selectedCityModel = null;
                                    _cityController.clear();
                                  });
                                }
                              },
                              onClear: _selectedStateModel != null
                                  ? () => setState(() {
                                        _selectedStateModel = null;
                                        _countryController.clear();
                                      })
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _LocationPickerField(
                              label: 'City',
                              icon: Icons.location_city,
                              value: _selectedCityModel?.name ?? _cityController.text,
                              onTap: () async {
                                if (_selectedStateModel == null) {
                                  ToastOverlay.show(context, 'Select State first');
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
                              },
                              onClear: _selectedCityModel != null
                                  ? () => setState(() {
                                        _selectedCityModel = null;
                                        _cityController.clear();
                                      })
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      _FormFieldWithIcon(
                        label: 'Address',
                        controller: _addressController,
                        icon: Icons.place,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Listing type',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: AppColors.labelDarkSecondary,
                          height: 24 / 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BookingChips(
                        options: const ['Rental', 'Sale'],
                        selected: _listingType == 'rental' ? 'Rental' : 'Sale',
                        onSelectionChanged: (s) {
                          setState(() =>
                              _listingType = s.toLowerCase());
                        },
                      ),
                      const SizedBox(height: 24),

                      _FormFieldWithIcon(
                        label: 'Seats',
                        controller: _seatsController,
                        icon: Icons.people,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: _FormFieldWithIcon(
                              label: 'Wet price',
                              controller: _wetPriceController,
                              icon: Icons.attach_money,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _FormFieldWithIcon(
                              label: 'Dry price',
                              controller: _dryPriceController,
                              icon: Icons.attach_money,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 18 + MediaQuery.of(context).viewPadding.bottom),
            child: PrimaryButton(
              label: _submitting ? 'Advertising...' : 'Advertise',
              onPressed: _submitting ? null : _onAdvertisePressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPickerField extends StatelessWidget {
  const _LocationPickerField({
    required this.label,
    required this.icon,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final IconData icon;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.labelDarkSecondary,
            height: 24 / 12,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, size: 24, color: AppColors.labelBlack),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value.isEmpty ? 'Select...' : value,
                  style: TextStyle(
                    fontSize: 16,
                    color: value.isEmpty ? AppColors.textSecondary : AppColors.labelBlack,
                  ),
                ),
              ),
              if (onClear != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_FormField] build label="$label"');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.labelDarkSecondary,
            height: 24 / 12,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: (v) => debugPrint('⌨️ [_FormField] "$label" changed: "$v"'),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.labelBlack,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.navy800,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}

class _FormFieldWithIcon extends StatelessWidget {
  const _FormFieldWithIcon({
    required this.label,
    required this.controller,
    required this.icon,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    debugPrint('🧩 [_FormFieldWithIcon] build label="$label" icon=$icon');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.labelDarkSecondary,
            height: 24 / 12,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: (v) => debugPrint('⌨️ [_FormFieldWithIcon] "$label" changed: "$v"'),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.labelBlack,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            prefixIcon: Icon(icon, size: 24, color: AppColors.labelBlack),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.navy800,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
