import 'package:flutter/material.dart';
import 'package:skye_app/shared/models/location_models.dart';
import 'package:skye_app/shared/services/aircraft_api_service.dart';
import 'package:skye_app/shared/theme/app_colors.dart';
import 'package:skye_app/shared/widgets/location_picker_sheets.dart';

/// Filter bottom sheets for CFI listing. Same pattern as aircraft_filter_sheets.

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

/// Aircraft Type filter – API, code 1st / name 2nd, search by both, draggable
void showCfiAircraftTypeSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?) onApply,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _CfiAircraftTypeFilterSheet(
      currentValue: currentValue,
      onApply: onApply,
    ),
  );
}

class _CfiAircraftTypeFilterSheet extends StatefulWidget {
  const _CfiAircraftTypeFilterSheet({
    required this.currentValue,
    required this.onApply,
  });

  final String? currentValue;
  final void Function(String?) onApply;

  @override
  State<_CfiAircraftTypeFilterSheet> createState() => _CfiAircraftTypeFilterSheetState();
}

class _CfiAircraftTypeFilterSheetState extends State<_CfiAircraftTypeFilterSheet> {
  List<AircraftTypeModel> _types = [];
  bool _loading = true;
  String? _error;
  String? _selected;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.currentValue;
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
        debugPrint('✅ [CfiAircraftTypeFilterSheet] Loaded ${list.length} aircraft types');
      }
    } catch (e) {
      debugPrint('❌ [CfiAircraftTypeFilterSheet] Load error: $e');
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
                                final isSelected = _selected == t.code;
                                return InkWell(
                                  onTap: () => setState(() => _selected = isSelected ? null : t.code),
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
                            debugPrint('✅ [CfiAircraftTypeFilterSheet] Clear tapped');
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
                            debugPrint('✅ [CfiAircraftTypeFilterSheet] Apply tapped, selected: $_selected');
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

/// State filter – API list. onApply receives display name and optional StateModel for ID.
void showCfiStateSheet(
  BuildContext context, {
  required String? currentValue,
  required void Function(String?, StateModel?)? onApply,
  StateModel? selectedState,
}) async {
  StateModel? sel;
  if (selectedState != null) sel = selectedState;
  else if (currentValue != null && currentValue.isNotEmpty) {
    sel = StateModel(id: 0, name: currentValue, code: '');
  }
  final picked = await showStatePickerSheet(context, selected: sel);
  if (picked != null && onApply != null) {
    onApply(picked.name, picked);
  }
}

/// City filter – API list, requires stateId from State filter.
void showCfiCitySheet(
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
  CityModel? sel;
  if (selectedCity != null) sel = selectedCity;
  else if (currentValue != null && currentValue.isNotEmpty) {
    sel = CityModel(id: 0, name: currentValue);
  }
  final picked = await showCityPickerSheet(
    context,
    stateId: stateId,
    selected: sel,
  );
  if (picked != null && onApply != null) {
    onApply(picked.name, picked);
  }
}

/// Airport filter – API search.
void showCfiAirportSheet(
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

/// Date filter - placeholder for availability date
void showCfiDateSheet(
  BuildContext context, {
  required DateTime? currentValue,
  required void Function(DateTime?) onApply,
}) {
  DateTime? selected = currentValue;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, __) => _sheetFrame(
            title: 'Date',
            onApply: () {
              Navigator.of(ctx).pop();
              onApply(selected);
            },
            onClear: () {
              selected = null;
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColors.navy800,
                    onPrimary: AppColors.white,
                    surface: AppColors.white,
                    onSurface: AppColors.labelBlack,
                  ),
                  iconTheme: const IconThemeData(
                    color: AppColors.labelBlack,
                  ),
                  datePickerTheme: DatePickerThemeData(
                    headerForegroundColor: AppColors.labelBlack,
                    headerHeadlineStyle: const TextStyle(
                      color: AppColors.labelBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    headerHelpStyle: const TextStyle(
                      color: AppColors.labelBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    subHeaderForegroundColor: AppColors.labelBlack,
                    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.white;
                      }
                      return AppColors.labelBlack;
                    }),
                    dayStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.labelBlack,
                    ),
                    weekdayStyle: const TextStyle(
                      color: AppColors.labelBlack,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    yearStyle: const TextStyle(
                      color: AppColors.labelBlack,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    yearForegroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.white;
                      }
                      return AppColors.labelBlack;
                    }),
                    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.white;
                      }
                      return AppColors.labelBlack;
                    }),
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: selected ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateChanged: (d) => setModal(() => selected = d),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Aircraft Ownership: Yes, No
void showCfiAircraftOwnershipSheet(
  BuildContext context, {
  required bool? currentValue,
  required void Function(bool?) onApply,
}) {
  bool? selected = currentValue;

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModal) {
        Widget tile(String label, bool value) {
          final isSelected = selected == value;
          return InkWell(
            onTap: () => setModal(() => selected = (selected == value ? null : value)),
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

        return DraggableScrollableSheet(
          initialChildSize: 0.36,
          minChildSize: 0.2,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, __) => _sheetFrame(
            title: 'Aircraft Ownership',
            onApply: () {
              debugPrint('✅ [showCfiAircraftOwnershipSheet] Apply tapped, selected: $selected');
              Navigator.of(ctx).pop();
              onApply(selected);
            },
            onClear: () {
              debugPrint('✅ [showCfiAircraftOwnershipSheet] Clear tapped');
              selected = null;
              setModal(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  tile('Yes', true),
                  tile('No', false),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
