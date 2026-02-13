import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/location_picker_sheets.dart';

/// Filter bottom sheets for aircraft listing. Stay on same screen; no navigation.

const _sheetTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: AppColors.labelBlack,
);

const _sheetPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 20);

const _sheetTextStyle = TextStyle(
  fontSize: 14,
  color: AppColors.grayPrimary,
);

const _sheetSubtitleStyle = TextStyle(
  fontSize: 12,
  color: AppColors.grayDark,
);

Widget _sheetFrame({
  required String title,
  required Widget child,
  required VoidCallback onApply,
  VoidCallback? onClear,
}) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: _sheetPadding.copyWith(bottom: 16),
            child: Text(title, style: _sheetTitleStyle),
          ),
          Flexible(child: SingleChildScrollView(child: child)),
          Padding(
            padding: _sheetPadding,
            child: Row(
              children: [
                if (onClear != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClear,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.labelBlack,
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                if (onClear != null) const SizedBox(width: 12),
                Expanded(
                  flex: onClear != null ? 1 : 1,
                  child: FilledButton(
                    onPressed: onApply,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy800,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Rent/Buy: All, Rental, Sale (no search)
void showRentBuySheet(
  BuildContext context, {
  required String? currentType,
  required void Function(String? type) onApply,
}) {
  String? selected = currentType;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.36,
          minChildSize: 0.2,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scroll) => _sheetFrame(
            title: 'Rent / Buy',
            onApply: () {
              debugPrint('✅ [showRentBuySheet] Apply tapped, selected: $selected');
              Navigator.of(ctx).pop();
              onApply(selected);
            },
            onClear: () {
              debugPrint('✅ [showRentBuySheet] Clear tapped');
              selected = null;
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _choiceTile(ctx, setModal, 'All', null, selected, (v) => selected = v),
                  _choiceTile(ctx, setModal, 'Rental', 'rental', selected, (v) => selected = v),
                  _choiceTile(ctx, setModal, 'Sale', 'sale', selected, (v) => selected = v),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _choiceTile(
  BuildContext context,
  void Function(void Function()) setModal,
  String label,
  String? value,
  String? selected,
  void Function(String?) onSelect,
) {
  final isSelected = selected == value;
  return InkWell(
    onTap: () => setModal(() => onSelect(isSelected ? null : value)),
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.navy800 : AppColors.borderLight,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: _sheetTextStyle)),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
        ],
      ),
    ),
  );
}

/// Aircraft Type: API list, code 1st / name 2nd, search by both, draggable sheet
void showAircraftTypeSheet(
  BuildContext context, {
  required int? currentId,
  required void Function(int?) onApply,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AircraftTypeFilterSheet(
      currentId: currentId,
      onApply: onApply,
    ),
  );
}

class _AircraftTypeFilterSheet extends StatefulWidget {
  const _AircraftTypeFilterSheet({
    required this.currentId,
    required this.onApply,
  });

  final int? currentId;
  final void Function(int?) onApply;

  @override
  State<_AircraftTypeFilterSheet> createState() => _AircraftTypeFilterSheetState();
}

class _AircraftTypeFilterSheetState extends State<_AircraftTypeFilterSheet> {
  List<AircraftTypeModel> _types = [];
  bool _loading = true;
  String? _error;
  int? _selected;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.currentId;
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await AircraftApiService.instance.getAircraftTypes();
      if (mounted) {
        setState(() {
          _types = list;
          _loading = false;
        });
        debugPrint('✅ [AircraftTypeFilterSheet] Loaded ${list.length} aircraft types');
      }
    } catch (e) {
      debugPrint('❌ [AircraftTypeFilterSheet] Load error: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
          _types = [];
        });
      }
    }
  }

  List<AircraftTypeModel> get _filtered {
    final q = _searchController.text.toLowerCase().trim();
    if (q.isEmpty) return _types;
    return _types
        .where((t) =>
            t.code.toLowerCase().contains(q) || t.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: _sheetPadding.copyWith(bottom: 16),
                  child: Text('Aircraft Type', style: _sheetTitleStyle),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by code or name',
                      hintStyle: _sheetSubtitleStyle,
                      filled: true,
                      fillColor: AppColors.white,
                      prefixIcon: const Icon(Icons.search, color: AppColors.grayPrimary, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.borderLight),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: _sheetTextStyle,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  const SizedBox(height: 8),
                                  TextButton(onPressed: _load, child: const Text('Retry')),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _filtered.length,
                              itemBuilder: (_, i) {
                                final t = _filtered[i];
                                final isSelected = _selected == t.id;
                                return InkWell(
                                  onTap: () => setState(() => _selected = isSelected ? null : t.id),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.navy800.withValues(alpha: 0.08) : null,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? AppColors.navy800 : AppColors.borderLight,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(t.code, style: _sheetTextStyle),
                                              const SizedBox(height: 2),
                                              Text(t.name, style: _sheetSubtitleStyle),
                                            ],
                                          ),
                                        ),
                                        if (isSelected) const Icon(Icons.check_circle, color: AppColors.navy800, size: 22),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
                Padding(
                  padding: _sheetPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            debugPrint('✅ [AircraftTypeFilterSheet] Clear tapped');
                            setState(() => _selected = null);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.labelBlack,
                            side: const BorderSide(color: AppColors.borderLight),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            debugPrint('✅ [AircraftTypeFilterSheet] Apply tapped, selected: $_selected');
                            Navigator.of(context).pop();
                            widget.onApply(_selected);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.navy800,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showLocationFieldSheet(
  BuildContext context, {
  required String title,
  required String hint,
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  final controller = TextEditingController(text: currentValue ?? '');

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.36,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, __) => _sheetFrame(
        title: title,
        onApply: () {
          Navigator.of(ctx).pop();
          final v = controller.text.trim();
          onApply(v.isEmpty ? null : v);
        },
        onClear: () => controller.clear(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: _sheetSubtitleStyle,
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: _sheetTextStyle,
            textInputAction: TextInputAction.done,
          ),
        ),
      ),
    ),
  );
}

void showStateSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?, StateModel?)? onApply,
  StateModel? selectedState,
}) async {
  StateModel? sel = selectedState ?? (currentValue != null && currentValue.isNotEmpty ? StateModel(id: 0, name: currentValue, code: '') : null);
  final picked = await showStatePickerSheet(context, selected: sel);
  if (picked != null && onApply != null) {
    onApply(picked.name, picked);
  }
}

void showCitySheet(
  BuildContext context, {
  required int? stateId,
  required String? currentValue,
  required void Function(String?, CityModel?)? onApply,
  CityModel? selectedCity,
}) async {
  if (stateId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Select State first'),
        duration: Duration(milliseconds: 2500),
      ),
    );
    return;
  }
  CityModel? sel = selectedCity ?? (currentValue != null && currentValue.isNotEmpty ? CityModel(id: 0, name: currentValue) : null);
  final picked = await showCityPickerSheet(context, stateId: stateId, selected: sel);
  if (picked != null && onApply != null) {
    onApply(picked.name, picked);
  }
}

void showAirportSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?)? onApply,
  int? cityId,
}) async {
  final picked = await showAirportPickerSheet(
    context,
    cityId: cityId,
    initialSelected: [],
    multiSelect: false,
  );
  if (picked != null && onApply != null) {
    onApply(picked.displayLabel);
  }
}

/// Price: min / max + sort arrow (↑ ucuzdan pahalıya, ↓ pahalıdan ucuza)
void showPriceSheet(
  BuildContext context, {
  required double? minPrice,
  required double? maxPrice,
  required String? currentSort,
  required void Function(double? min, double? max, String? sort) onApply,
}) {
  final minCtrl = TextEditingController(text: minPrice != null ? minPrice.toInt().toString() : '');
  final maxCtrl = TextEditingController(text: maxPrice != null ? maxPrice.toInt().toString() : '');
  // ↑ price_asc (ucuzdan pahalıya), ↓ price_desc (pahalıdan ucuza). Tıklayınca toggle.
  String sort = currentSort == 'price_desc' ? 'price_desc' : 'price_asc';

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, __) => _sheetFrame(
            title: 'Price Range',
            onApply: () {
              Navigator.of(ctx).pop();
              final min = double.tryParse(minCtrl.text.trim());
              final max = double.tryParse(maxCtrl.text.trim());
              onApply(min, max, sort);
            },
            onClear: () {
              debugPrint('✅ [showPriceSheet] Clear tapped');
              minCtrl.clear();
              maxCtrl.clear();
              sort = 'price_asc';
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: minCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Min (\$)',
                        labelStyle: _sheetSubtitleStyle,
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: _sheetTextStyle,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: maxCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Max (\$)',
                        labelStyle: _sheetSubtitleStyle,
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: _sheetTextStyle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setModal(() {
                        sort = sort == 'price_desc' ? 'price_asc' : 'price_desc';
                      }),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cfiBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          sort == 'price_desc' ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 24,
                          color: AppColors.navy800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
